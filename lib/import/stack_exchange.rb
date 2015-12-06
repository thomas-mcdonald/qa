require 'import/stack_exchange/comment'
require 'import/stack_exchange/edit'
require 'vote_creator'

module QA
  module Import
    class StackExchange
      def initialize(dir)
        @conn = ActiveRecord::Base.connection.raw_connection
        Rails.logger.level = Logger::WARN
        @dir = dir
        @posts = []
        output_intro
        @user_ids = create_users
        create_posts
        create_comments
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
        begin
          users_doc.each do |u|
            bar.increment
            next if u["Id"].to_i < 0
            time = DateTime.now
            @conn.put_copy_data(%(#{u["Id"]},"#{u["DisplayName"]}","#{Faker::Internet.safe_email}", #{time}, #{time}\n))
            user_ids << u["Id"].to_i
          end
        ensure
          @conn.put_copy_end
        end
        user_ids
      end

      def create_posts
        posts = Nokogiri::XML::Document.parse(File.read("#{@dir}/posts.xml")).css('posts row')
        post_histories = Nokogiri::XML::Document.parse(File.read("#{@dir}/posthistory.xml")).css('posthistory row')
        questions = posts.select { |p| p["PostTypeId"] == "1" }
        answers = posts.select { |p| p["PostTypeId"] == "2" }

        grouped_edits = build_edits(post_histories)
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

      def create_comments
        comments = Nokogiri::XML::Document.parse(File.read("#{@dir}/comments.xml")).css('comments row')
        puts " Creating Comments"
        bar = progress_bar('Comments', comments.length)
        comments.each do |row|
          bar.increment
          se_comment = StackExchange::Comment.new(row)
          info = @posts[se_comment.post_id]
          next unless info
          comment = se_comment.build_object(info)
          comment.save
        end
      end

      def create_votes
        voterow = Nokogiri::XML::Document.parse(File.read("#{@dir}/votes.xml")).css('votes row')
        puts " Creating votes"

        user_ids = User.pluck(:id)
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
        puts "Building reputation events"
        re = []
        bar = ProgressBar.create(title: 'Reputation', total: Vote.count, format: '%t: |%B| %E')
        Vote.all.each do |v|
          re << ReputationEvent.new(
            action: v,
            event_type: %(give_#{v.event_type}),
            user: v.user
          )
          re << ReputationEvent.new(
            action: v,
            event_type: %(receive_#{v.event_type}),
            user: v.post.user
          )
          bar.increment
        end

        puts "Inserting reputation events"
        @conn.exec('COPY reputation_events (user_id, event_type, action_type, action_id, created_at, updated_at) FROM STDIN WITH CSV')
        bar = progress_bar('RepEvents', re.count)
        re.each do |r|
          event_id = ReputationEvent.event_types[r.event_type]
          puts r && next if event_id.nil?
          @conn.put_copy_data(
            %(#{r.user_id},#{event_id},"#{r.action_type}",#{r.action_id},#{r.created_at},#{r.updated_at}\n)
          )
          bar.increment
        end
        @conn.put_copy_end

        puts "Calculating reputation"
        bar = ProgressBar.create(title: 'Recounting', total: User.count, format: '%t: |%B| %E')
        User.all.each do |u|
          bar.increment
          u.calculate_reputation!
        end
      end

      def update_counters
        print " Updating cache counters & creating background jobs for badges"
        Question.all.each do |q|
          Jobs::QuestionStats.new.perform(q.id)
          Jobs::Badge.perform_async(:question_vote, q.to_global_id)
        end
        Answer.all.each do |a|
          Jobs::AnswerStats.new.perform(a.id)
          Jobs::Badge.perform_async(:answer_vote, a.to_global_id)
        end
        puts " - done!"
      end

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
        guidgroups.each do |_, edit|
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
          edits = grouped_edits[q['Id']]
          originator = edits.select(&:new_record)[0]
          edits.delete originator

          # we can't handle anonymous users right now
          next unless @user_ids.include? originator[:user_id].to_i

          qc = QuestionCreator.new(User.find(originator[:user_id]), originator.simple_hash)
          qu = qc.create
          # if the record saved
          if !qu.new_record?
            @posts[q['Id'].to_i] = { id: qu.id, type: 'Question' }

            # add dummy view count data
            redis_values = (1..q['ViewCount'].to_i).to_a
            $view.pfadd("question-#{qu.id}", redis_values)
          end
        end
      end

      def create_answers(answers, grouped_edits)
        puts " Creating and inserting answers"
        bar = progress_bar('Answers', answers.length)
        answers.each do |a|
          bar.increment
          next if @posts[a['ParentId'].to_i].blank?
          edits = grouped_edits[a['Id']]
          originator = edits.select(&:new_record)[0]
          edits.delete originator
          next unless @user_ids.include? originator[:user_id].to_i

          question = Question.find_by(id: @posts[a['ParentId'].to_i][:id])
          next if question.nil?
          ac = AnswerCreator.new(question, User.find(originator[:user_id]), originator.simple_hash)
          an = ac.create

          @posts[a['Id'].to_i] = { id: an.id, type: 'Answer' } unless an.new_record?
        end
      end
    end
  end
end
