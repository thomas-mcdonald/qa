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

      class Edit
        def initialize(edit)
          @result = {
            post_id: edit[0]['PostId'],
            comment: edit[0]['Comment'],
            user_id: edit[0]['UserId'],
            created_at: edit[0]['CreationDate']
          }

          edit.each do |attr|
            @result[:new_record] = true if [1, 2, 3].include? attr['PostHistoryTypeId'].to_i
            case attr['PostHistoryTypeId']
            when "1", "4", "7"
              @result[:title] = attr["Text"]
            when "2", "5", "8"
              @result[:body] = attr["Text"]
            when "3", "6", "9"
              # Handle what appears to be an edge case where a question has no tags... sigh.
              if attr["Text"]
                @result[:tag_list] = attr["Text"].split("><").each { |t| t.gsub!(/[<>]/, "") }.join(",")
              else
                @result[:tag_list] = "untagged"
              end
            end
          end

          def [](sym)
            @result[sym]
          end
        end
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

        puts "Creating and inserting questions"
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

        puts "Creating and inserting answers"
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
#          an.last_active_user_id = @users[originator[:user_id].to_i].id
          an.created_at = DateTime.parse(originator[:created_at])
#          an.last_active_at = DateTime.parse(originator[:created_at])
          next unless an.save
          posts[a['Id'].to_i] = { id: an.id, type: 'Answer' } unless an.new_record?
        end
        posts
      end

      def create_votes
        voterow = Nokogiri::XML::Document.parse(File.read("#{@dir}/votes.xml")).css('votes row')
        puts "Loaded votes"

        size = User.count
        users = User.all
        votes = []
        voterow.each do |row|
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
        Vote.import votes
      end

      def update_counters
        puts "updating cache column counters"
        Question.all.each do |q|
          Question.update_counters q.id, answers_count: q.answers.length
          q.update_vote_count!
        end
        Answer.all.each do |a|
          a.update_vote_count!
        end
      end

      def build_edits(post_histories)
        puts "sorting histories by GUID"
        bar = ProgressBar.create(title: 'Sorting', total: post_histories.length, format: '%t: |%B| %E')
        guidgroups = Hash.new { |hash, key| hash[key] = [] }
        post_histories.each do |row|
          bar.increment
          guidgroups[row['RevisionGUID']] << row
        end
        puts "grouping GUIDs into single edits"
        bar = ProgressBar.create(title: 'Grouping', total: post_histories.length, format: '%t: |%B| %E')
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