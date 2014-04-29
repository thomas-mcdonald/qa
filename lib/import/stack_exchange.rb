require 'import/stack_exchange/edit'
require 'vote_creator'

module QA
  module Import
    class StackExchange
      def initialize(dir)
        @conn = ActiveRecord::Base.connection.raw_connection
        @dir = dir
        @posts = []
        output_intro
        @user_ids = create_users
        create_posts
        create_votes
        create_reputation
        update_counters
        ActiveRecord::Base.clear_active_connections!
      end

      def output_intro
        puts " Welcome to QA."
        puts " Importing from a Stack Exchange Data Dump"
      end

      def create_users
        users_doc = Nokogiri::XML::Document.parse(File.read("#{@dir}/users.xml")).css('users row')
        puts " Creating Users"
        bar = progress_bar('Users', users_doc.length)
        user_ids = []
        @conn.exec('COPY users (id, name, email, created_at, updated_at) FROM STDIN WITH CSV')
        users_doc.each do |u|
          bar.increment
          next if u["Id"].to_i < 0
          time = DateTime.now
          @conn.put_copy_data(%(#{u["Id"]},"#{u["DisplayName"]}","#{FactoryGirl.generate(:email)}", #{time}, #{time}\n))
          user_ids << u["Id"].to_i
        end
        @conn.put_copy_end
        user_ids
      end

      def create_posts
        posts = Nokogiri::XML::Document.parse(File.read("#{@dir}/posts.xml")).css('posts row')
        post_histories = Nokogiri::XML::Document.parse(File.read("#{@dir}/posthistory.xml")).css('posthistory row')
        questions = posts.select { |p| p["PostTypeId"] == "1" }
        answers = posts.select { |p| p["PostTypeId"] == "2" }

        grouped_edits = build_edits(post_histories)
        post_histories = nil
        posts = nil

        # create posts
        create_questions(questions, grouped_edits)
        create_answers(answers, grouped_edits)

        puts " Updating accepted answer IDs"
        bar = progress_bar('Accepting', questions.length)
        questions.each do |q|
          bar.increment
          info = @posts[q['Id'].to_i]
          answer_info = @posts[q['AcceptedAnswerId'].to_i]
          next unless answer_info # answer doesn't exist... for whatever reason
          Question.update(info[:id], accepted_answer_id: answer_info[:id])
        end
        posts
      end

      def create_votes
        voterow = Nokogiri::XML::Document.parse(File.read("#{@dir}/votes.xml")).css('votes row')
        puts " Creating votes"

        size = User.count
        user_ids = User.pluck(:id)
        votes = []
        bar = progress_bar('Votes', voterow.count)
        @conn.exec('COPY votes (user_id, post_id, post_type, vote_type, created_at, updated_at) FROM STDIN WITH CSV')

        voterow.each do |row|
          bar.increment
          next unless [2, 3].include? row['VoteTypeId'].to_i
          next if @posts[row['PostId'].to_i].blank?

          post_id = @posts[row['PostId'].to_i][:id]
          post_type = @posts[row['PostId'].to_i][:type]
          vote_type = Vote.vote_types['upvote'] if row['VoteTypeId'].to_i == 2
          vote_type = Vote.vote_types['downvote'] if row['VoteTypeId'].to_i == 3
          user_id = user_ids.sample
          created_at = DateTime.parse row['CreationDate']
          updated_at = DateTime.parse row['CreationDate']
          @conn.put_copy_data(%(#{user_id},#{post_id},"#{post_type}",#{vote_type},#{created_at},#{updated_at}\n))
        end
        @conn.put_copy_end
      end

      def create_reputation
        vc = VoteCreator.new(User.new, post_id: 0, post_type: '', vote_type: 0)
        puts "Creating reputation events"
        bar = ProgressBar.create(title: 'Reputation', total: Vote.count, format: '%t: |%B| %E')
        Vote.all.each do |v|
          bar.increment
          vc.instance_variable_set(:@vote, v)
          vc.send(:create_reputation_events)
        end
        puts "Calculating reputation"
        bar = ProgressBar.create(title: 'Recounting', total: User.count, format: '%t: |%B| %E')
        User.all.each do |u|
          bar.increment
          u.calculate_reputation!
        end
      end

      def update_counters
        print " Queueing updates to cache column counters"
        Question.all.each { |q| Jobs::QuestionStats.perform_async(q.id) }
        Answer.all.each { |a| Jobs::AnswerStats.perform_async(a.id) }
        puts " - done!"
      end

      # Although all the methods above should probably be private, these are only
      # used internally in the ones above.
      private

      def build_edits(post_histories)
        puts " Sorting histories by GUID"
        bar = progress_bar('Sorting', post_histories.length)
        guidgroups = Hash.new { |hash, key| hash[key] = [] }
        post_histories.each do |row|
          bar.increment
          guidgroups[row['RevisionGUID']] << row
        end
        puts " Grouping GUIDs into single edits"
        bar = progress_bar('Grouping', guidgroups.length)
        groupededits = Hash.new { |hash, key| hash[key] = [] }
        guidgroups.each do |key, edit|
          eobj = StackExchange::Edit.new(edit)
          bar.increment
          groupededits[eobj.post_id] << eobj
        end
        groupededits
      end

      def progress_bar(title, length)
        ProgressBar.create(title: title, total: length, format: '%t: |%B| %E')
      end

      def create_questions(questions, grouped_edits)
        puts " Creating and inserting questions"
        bar = progress_bar('Questions', questions.length)
        questions.each do |q|
          bar.increment
          qu = Question.new
          edits = grouped_edits[q['Id']]
          originator = (edits.select { |v| v[:new_record] == true })[0]
          edits.delete originator

          # we can't handle anonymous users right now
          next unless @user_ids.include? originator[:user_id].to_i

          qu.assign_attributes(originator.simple_hash)
          qu.user_id = originator[:user_id].to_i
          qu.last_active_user_id = originator[:user_id].to_i
          qu.save
          @posts[q['Id'].to_i] = { id: qu.id, type: 'Question' } unless qu.new_record?
        end
      end

      def create_answers(answers, grouped_edits)
        puts " Creating and inserting answers"
        bar = progress_bar('Answers', answers.length)
        answers.each do |a|
          bar.increment
          next if @posts[a['ParentId'].to_i].blank?
          an = Answer.new
          edits = grouped_edits[a['Id']]
          originator = (edits.select { |v| v[:new_record] == true })[0]
          edits.delete originator
          next unless @user_ids.include? originator[:user_id].to_i

          an.question_id = @posts[a['ParentId'].to_i][:id]
          an.body = originator[:body]
          an.user_id = originator[:user_id].to_i
          an.created_at = DateTime.parse(originator[:created_at])
          next unless an.save
          @posts[a['Id'].to_i] = { id: an.id, type: 'Answer' } unless an.new_record?
        end
      end
    end
  end
end
