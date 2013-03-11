module QA
  module Import
    class StackExchange
      def initialize(dir)
        @dir = dir
        @users = create_users
        create_posts
      end

      class Edit
        def initialize(edit)
          @result = {
            :post_id => edit[0]['PostId'],
            :comment => edit[0]['Comment'],
            :user_id => edit[0]['UserId'],
            :created_at => edit[0]['CreationDate']
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

      def create_users
        users_doc = Nokogiri::XML::Document.parse(File.read("#{@dir}/users.xml")).css('users row')
        users = []
        users_doc.each do |u|
          next if u["Id"].to_i < 0
          users << User.new(name: u["DisplayName"], email: FactoryGirl.generate(:email), id: u["Id"])
        end
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

        puts "Beginning insertion of questions"
        posts = []
        questions.each do |q|
          qu = Question.new
          edits = grouped_edits[q['Id']]
          originator = (edits.select { |v| v[:new_record] == true })[0]
          edits.delete originator
          next unless @users[originator[:user_id].to_i] # we can't handle anonymous users right now

          qu.title = originator[:title]
          qu.body = originator[:body]
          qu.user_id = @users[originator[:user_id].to_i].id
          qu.created_at = DateTime.parse(originator[:created_at])
          qu.save
          posts[q['Id'].to_i] = { id: qu.id, type: 'Question' } unless qu.new_record?
        end

        puts "inserting answers"
        answers.each do |a|
          next if posts[a['ParentId'].to_i].blank?
          an = Answer.new
          edits = grouped_edits[a['Id']]
          originator = (edits.select { |v| v[:new_record] == true })[0]
          edits.delete originator
          next unless @users[originator[:user_id].to_i]

          an.question_id = posts[a['ParentId'].to_i][:id]
          an.body = originator[:body]
          an.user_id = @users[originator[:user_id].to_i]
          an.created_at = DateTime.parse(originator[:created_at])
          next unless an.save
          posts[a['Id'].to_i] = { id: an.id, type: 'Answer' } unless an.new_record?
        end
      end

      def build_edits(post_histories)
        puts "sorting histories by GUID"
        guidgroups = Hash.new { |hash, key| hash[key] = [] }
        post_histories.each do |row|
          guidgroups[row['RevisionGUID']] << row
        end
        puts "grouping GUIDs into single edits"
        groupededits = Hash.new { |hash, key| hash[key] = [] }
        guidgroups.each do |key, edit|
          groupededits[edit[0]['PostId']] << StackExchange::Edit.new(edit)
        end
        groupededits
      end
    end
  end
end