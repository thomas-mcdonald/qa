require 'import/stack_exchange/edit'
require 'vote_creator'

module QA
  module Import
    class StackExchange
      def initialize(dir)
        @dir = dir
        @posts = []
        output_intro
        @users = create_users
        create_posts
        create_votes
        create_reputation
        update_counters
      end

      def output_intro
        puts " Welcome to QA."
        puts " Importing from a Stack Exchange Data Dump"
      end

      def create_users
        users_doc = Nokogiri::XML::Document.parse(File.read("#{@dir}/users.xml")).css('users row')
        puts " Creating Users"
        bar = progress_bar('Users', users_doc.length)
        users = []
        users_doc.each do |u|
          bar.increment
          next if u["Id"].to_i < 0
          users << User.new(name: u["DisplayName"], email: FactoryGirl.generate(:email), id: u["Id"])
        end
        puts " Importing Users"
        import_users(users)
      end

      def create_posts
        posts = Nokogiri::XML::Document.parse(File.read("#{@dir}/posts.xml")).css('posts row')
        post_histories = Nokogiri::XML::Document.parse(File.read("#{@dir}/posthistory.xml")).css('posthistory row')
        questions = posts.select { |p| p["PostTypeId"] == "1" }
        answers = posts.select { |p| p["PostTypeId"] == "2" }

        grouped_edits = build_edits(post_histories)
        post_histories = nil
        posts = nil

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
        users = User.all
        votes = []
        bar = progress_bar('Votes', voterow.count)
        voterow.each do |row|
          bar.increment
          next unless [2, 3].include? row['VoteTypeId'].to_i
          next if @posts[row['PostId'].to_i].blank?
          vote = Vote.new
          vote.post_id = @posts[row['PostId'].to_i][:id]
          vote.post_type = @posts[row['PostId'].to_i][:type]
          vote.vote_type_id = 1 if row['VoteTypeId'].to_i == 2
          vote.vote_type_id = 2 if row['VoteTypeId'].to_i == 3
          vote.user = users[(rand*size).floor]
          vote.created_at = DateTime.parse row['CreationDate']
          vote.updated_at = DateTime.parse row['CreationDate']
          votes << vote
        end
        # Not much point in validating this data... it doesn't matter *that*
        # much if someone upvotes themselves or multiple posts, but it does
        # create fuck loads of select queries.
        #
        # I guess if a user has already voted on a post we should removed them
        # from possible selection, which would essentially do the validation
        # there instead.
        Vote.import(votes, validate: false)
      end

      def create_reputation
        vc = VoteCreator.new(User.new, post_id: 0, post_type: '', vote_type_id: 0)
        puts "Creating reputation events"
        bar = ProgressBar.create(title: 'Reputation', total: Vote.count, format: '%t: |%B| %E')
        Vote.all.each do |v|
          bar.increment
          vc.instance_variable_set(:@vote, v)
          vc.create_reputation_events
        end
        puts "Calculating reputation"
        bar = ProgressBar.create(title: 'Recounting', total: User.count, format: '%t: |%B| %E')
        User.all.each do |u|
          bar.increment
          u.calculate_reputation!
        end
      end

      def update_counters
        puts " Updating cache column counters"
        bar = progress_bar('Question counters', Question.count)
        Question.all.each do |q|
          bar.increment
          Question.update_counters q.id, answers_count: q.answers.length
          q.update_vote_count!
        end
        bar = progress_bar('Answer counters', Answer.count)
        Answer.all.each do |a|
          bar.increment
          a.update_vote_count!
        end
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
          bar.increment
          groupededits[edit[0]['PostId']] << StackExchange::Edit.new(edit)
        end
        groupededits
      end

      # import_users takes an array of ActiveRecord user models and imports
      # them to the database, after which we return a hash which maps user IDs
      # to the AR objects
      def import_users(users)
        User.import users
        uhash = {}
        users.each { |u| uhash[u.id] = u }
        uhash
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
          next unless @users[originator[:user_id].to_i] # we can't handle anonymous users right now

          qu.assign_attributes(originator.simple_hash)
          qu.user_id = @users[originator[:user_id].to_i].id
          qu.last_active_user_id = @users[originator[:user_id].to_i].id
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
          next unless @users[originator[:user_id].to_i]

          an.question_id = @posts[a['ParentId'].to_i][:id]
          an.body = originator[:body]
          an.user_id = @users[originator[:user_id].to_i].id
          an.created_at = DateTime.parse(originator[:created_at])
          next unless an.save
          @posts[a['Id'].to_i] = { id: an.id, type: 'Answer' } unless an.new_record?
        end
      end
    end
  end
end