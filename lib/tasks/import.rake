namespace :import do
  task :all => :environment do
    Rails.logger.level = Logger::FATAL

    postsxml = Nokogiri::XML(File.open(Rails.root + "lib/importdata/posts.xml"))
    posthistoryxml = Nokogiri::XML(File.open(Rails.root + "lib/importdata/posthistory.xml"))
    puts "Loaded posts + histories"
    usersxml = Nokogiri::XML(File.open(Rails.root + "lib/importdata/users.xml")).css('users row').select { |u| u['Id'].to_i != -1 }

    puts "Loaded users"
    votesxml = Nokogiri::XML(File.open(Rails.root + "lib/importdata/votes.xml"))

    users, i = [], 0
    pbar = ProgressBar.new("adding users", usersxml.length)
    usersxml.each do |user|
      i += 1
      u = User.new(
        :display_name => user['DisplayName'],
        :about_me => user['AboutMe'],
        :email => "example-#{i}@example.com"
      )
      u.username = user['DisplayName'].gsub(/[^0-9a-zA-Z@_\.]/, '') + i.to_s
      u.created_at = Date.parse(user['CreationDate'])
      u.password_hash = "$2a$10$GNApXWcXPJ2ro5vgwMyo1.yGldKMZJcJnkDPXBoVNNpeF4Z2KBlpW"
      u.password_salt = "$2a$10$GNApXWcXPJ2ro5vgwMyo1."
      users[user['Id'].to_i] = u
      u.save(:validate => false)
      pbar.inc
    end

    # Tidy up stuff from user loading
    usersxml = nil
    i = nil
    puts "\n"

    # Posts.
    posts_count, questions, answers = 0, [], []
    puts "sorting questions & answers"
    postsxml.css('posts row').each do |post|
      if post['PostTypeId'] == "1"
        questions << post
      elsif post['PostTypeId'] == "2"
        answers << post
      end
    end
    puts "sorting histories by GUID"
    guidgroups = {}
    posthistoryxml.css('posthistory row').each do |row|
      guidgroups[row['RevisionGUID']] = [] unless guidgroups[row['RevisionGUID']]
      guidgroups[row['RevisionGUID']] << row
    end
    puts "grouping GUIDs into single edits"
    groupededits = {}
    guidgroups.each do |key, edit|
      groupededits[edit[0]['PostId']] = [] unless groupededits[edit[0]['PostId']]
      result = { 
        :post_id => edit[0]['PostId'],
        :comment => edit[0]['Comment'],
        :user_id => edit[0]['UserId'],
        :created_at => edit[0]['CreationDate']
      }
      edit.each do |attr|
        result[:new_record] = true if [1, 2, 3].include? attr['PostHistoryTypeId'].to_i
        case attr['PostHistoryTypeId']
        when "1", "4", "7"
          result[:title] = attr["Text"]
        when "2", "5", "8"
          result[:body] = attr["Text"]
        when "3", "6", "9"
          # Handle what appears to be an edge case where a question has no tags... sigh.
          if attr["Text"]
            result[:tag_list] = attr["Text"].split("><").each { |t| t.gsub!(/[<>]/, "") }.join(",")
          else
            result[:tag_list] = "untagged"
          end
        end
      end
      groupededits[edit[0]['PostId']] << result
    end

    puts "Beginning insertion of questions"
    posts = []
    pbar = ProgressBar.new("ins. questions", questions.length)
    questions.each do |q|
      qu = Question.new
      edits = groupededits[q['Id']]
      originator = (edits.select { |v| v[:new_record] == true })[0]
      edits.delete originator
      PaperTrail.whodunnit = users[originator[:user_id].to_i]
      qu.title = originator[:title]
      qu.body = originator[:body]
      qu.tag_list = originator[:tag_list]
      qu.user = users[originator[:user_id].to_i]
      qu.created_at = DateTime.parse(originator[:created_at])
      qu.last_activity_at = DateTime.parse(originator[:created_at])
      qu.last_active_user = users[originator[:user_id].to_i]
      qu.save
      # We can now iterate through each edit and apply it on top of the question
      edits.each do |edit|
        PaperTrail.whodunnit = users[edit[:user_id].to_i]
        qu.title = edit[:title] if edit[:title]
        qu.body = edit[:body] if edit[:body]
        qu.tag_list = edit[:tag_list] if edit[:tag_list]
        qu.last_active_user = users[edit[:user_id].to_i]
        qu.last_activity_at = DateTime.parse(edit[:created_at])
        qu.updated_at = DateTime.parse(edit[:created_at])
        qu.save
      end
      pbar.inc
      posts[q['Id'].to_i] = qu unless qu.new_record?
    end

    #
    # Answers.
    pbar = ProgressBar.new("adding answers", answers.length)
    puts "inserting answers"
    answers.each do |a|
      an = Answer.new
      edits = groupededits[a['Id']]
      postrow = postsxml.css("posts row[Id='#{ a['Id'] }']")[0]
      originator = edits.select { |v| v[:new_record] = true }[0]
      edits.delete originator
      PaperTrail.whodunnit = users[originator[:user_id].to_i] 
      an.question = posts[postrow['ParentId'].to_i]
      an.body = originator[:body]
      an.user = users[originator[:user_id].to_i]
      an.created_at = DateTime.parse(originator[:created_at])
      an.save
      edits.each do |edit|
        PaperTrail.whodunnit = users[edit[:user_id].to_i]
        an.body = edit[:body]
        an.updated_at = DateTime.parse(edit[:created_at])
        an.save
      end
      posts[a['Id'].to_i] = an unless an.new_record?
      pbar.inc
    end

    #
    # Votes.
    size = User.count
    voterow = votesxml.css('votes row')
    pbar = ProgressBar.new("adding votes", voterow.length)
    voterow.each do |row|
      next unless [2, 3].include? row['VoteTypeId'].to_i
      next if posts[row['PostId'].to_i].blank?
      vote = posts[row['PostId'].to_i].votes.new
      vote.value = 1 if row['VoteTypeId'].to_i == 2
      vote.value = -1 if row['VoteTypeId'].to_i == 3
      vote.user = User.offset((rand*size).ceil).first
      vote.created_at = DateTime.parse row['CreationDate']
      vote.updated_at = DateTime.parse row['CreationDate']
      vote.save
      pbar.inc
    end
  end
end
