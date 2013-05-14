require 'import/stack_exchange/edit'

module QA
  module Import
    class StackExchange
      def initialize(dir)
        @dir = dir
        output_intro
        @users = create_users
        @posts = create_posts
        create_votes
        update_counters
      end

      def output_intro
        puts " Welcome to QA."
        puts " Importing from a Stack Exchange Data Dump"
      end

      def create_users
        users_doc = Nokogiri::XML::Document.parse(File.read("#{@dir}/users.xml")).css('users row')
        puts " Creating Users"
        bar = ProgressBar.create(title: 'Users', total: users_doc.length, format: '%t: |%B| %E')
        users = []
        users_doc.each do |u|
          bar.increment
          next if u["Id"].to_i < 0
          users << User.new(name: u["DisplayName"], email: FactoryGirl.generate(:email), id: u["Id"])
        end
        puts " Importing Users"
        User.import users
        uhash = {}
        users.each do |u|
          uhash[u.id] = u
        end
        uhash
      end

      def create_posts
        posts = Nokogiri::XML::Document.parse(File.read("#{@dir}/posts.xml")).css('posts row')
        post_histories = Nokogiri::XML::Document.parse(File.read("#{@dir}/posthistory.xml")).css('posthistory row')
        questions = posts.select { |p| p["PostTypeId"] == "1" }
        answers = posts.select { |p| p["PostTypeId"] == "2" }

        grouped_edits = build_edits(post_histories)

        puts " Creating and inserting questions"
        bar = ProgressBar.create(title: 'Questions', total: questions.length, format: '%t: |%B| %E')
        posts = []
        questions.each do |q|
          bar.increment
          qu = Question.new
          edits = grouped_edits[q['Id']]
          originator = (edits.select { |v| v[:new_record] == true })[0]
          edits.delete originator
          next unless @users[originator[:user_id].to_i] # we can't handle anonymous users right now

          qu.title = originator[:title]
          qu.body = originator[:body]
          qu.tag_list = originator[:tag_list]
          qu.user_id = @users[originator[:user_id].to_i].id
          qu.last_active_user_id = @users[originator[:user_id].to_i].id
          qu.created_at = DateTime.parse(originator[:created_at])
          qu.last_active_at = DateTime.parse(originator[:created_at])
          qu.save
          posts[q['Id'].to_i] = { id: qu.id, type: 'Question' } unless qu.new_record?
        end

        puts " Creating and inserting answers"
        bar = ProgressBar.create(title: 'Answers', total: answers.length, format: '%t: |%B| %E')
        answers.each do |a|
          bar.increment
          next if posts[a['ParentId'].to_i].blank?
          an = Answer.new
          edits = grouped_edits[a['Id']]
          originator = (edits.select { |v| v[:new_record] == true })[0]
          edits.delete originator
          next unless @users[originator[:user_id].to_i]

          an.question_id = posts[a['ParentId'].to_i][:id]
          an.body = originator[:body]
          an.user_id = @users[originator[:user_id].to_i].id
          an.created_at = DateTime.parse(originator[:created_at])
          next unless an.save
          posts[a['Id'].to_i] = { id: an.id, type: 'Answer' } unless an.new_record?
        end
        posts
      end

      def create_votes
        voterow = Nokogiri::XML::Document.parse(File.read("#{@dir}/votes.xml")).css('votes row')
        puts " Creating votes"

        size = User.count
        users = User.all
        votes = []
        bar = ProgressBar.create(title: 'Votes', total: voterow.count, format: '%t: |%B| %E')
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

        puts " Inserting votes"
        votes.each_slice(50) do |vote|
          Vote.import vote
        end
      end

      def update_counters
        puts " Updating cache column counters"
        bar = ProgressBar.create(title: 'Question counters', total: Question.count, format: '%t: |%B| %E')
        Question.all.each do |q|
          bar.increment
          Question.update_counters q.id, answers_count: q.answers.length
          q.update_vote_count!
        end
        bar = ProgressBar.create(title: 'Answer counters', total: Answer.count, format: '%t: |%B| %E')
        Answer.all.each do |a|
          bar.increment
          a.update_vote_count!
        end
      end

      def build_edits(post_histories)
        puts " Sorting histories by GUID"
        bar = ProgressBar.create(title: 'Sorting', total: post_histories.length, format: '%t: |%B| %E')
        guidgroups = Hash.new { |hash, key| hash[key] = [] }
        post_histories.each do |row|
          bar.increment
          guidgroups[row['RevisionGUID']] << row
        end
        puts " Grouping GUIDs into single edits"
        bar = ProgressBar.create(title: 'Grouping', total: guidgroups.length, format: '%t: |%B| %E')
        groupededits = Hash.new { |hash, key| hash[key] = [] }
        guidgroups.each do |key, edit|
          bar.increment
          groupededits[edit[0]['PostId']] << StackExchange::Edit.new(edit)
        end
        groupededits
      end
    end
  end
end