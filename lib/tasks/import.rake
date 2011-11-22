namespace :import do
  task :all => :environment do
    # Memoize & reset some versioning callbacks
    Tag.class_eval %(
      @@tageh = {}
      def self.find_or_create_by_name(name)
        return @@tageh[name] unless @@tageh[name].blank?
        @@tageh[name] = Tag.create(:name => name)
        @@tageh[name]
      end
    
      def self.reset_tageh
        @@tageh = nil
      end)

    [Question, Answer].each do |klass|
      klass.reset_callbacks(:create)
      klass.reset_callbacks(:update)
      klass.reset_callbacks(:save)
      klass.skip_callback(:create, :after, :record_create)
      klass.skip_callback(:update, :before, :record_update)
      klass.class_eval %(
        def record_create
          if switched_on?
            self.versions.new merge_metadata(:event => 'create', :whodunnit => PaperTrail.whodunnit)
          end
        end

        def record_update
          if switched_on? && changed_notably?
            data = {
              :event     => 'update',
              :object    => object_to_string(item_before_change),
              :whodunnit => PaperTrail.whodunnit
            }
            if version_class.column_names.include? 'object_changes'
              # The double negative (reject, !include?) preserves the hash structure of self.changes.
              data[:object_changes] = self.changes.reject do |key, value|
                !notably_changed.include?(key)
              end.to_yaml
            end
            self.versions.new merge_metadata(data)
          end
        end
      )
    end

    Vote.class_eval %(
        def return_reputation_event(item)
          return unless item.respond_to? :user_id
          return unless ["Question", "Answer"].include? self.voteable_type
          r = ReputationEvent.new
          r.reputable = self
          r.user_id = item.user_id
          # TODO: switch based on the value of votable type
          if self.voteable_type == "Question"
            if self.value == 1
              r.value = 1
            elsif self.value == -1
              r.value = 2
            end
          elsif self.voteable_type == "Answer"
            if self.value == 1
              r.value = 3
            elsif self.value == -1
              r.value = 4
            end
          end
          r
        end
    )

    # Not sure if this is needed
    Rails.application.config.active_record.identity_map = true
    Rails.logger.level = Logger::FATAL

    #
    # Setup.
    postsxml = Nokogiri::XML(File.open(Rails.root + "lib/importdata/posts.xml"))
    posthistoryxml = Nokogiri::XML(File.open(Rails.root + "lib/importdata/posthistory.xml"))
    puts "Loaded posts + histories"

    usersxml = Nokogiri::XML(File.open(Rails.root + "lib/importdata/users.xml")).css('users row').select { |u| u['Id'].to_i != -1 }
    puts "Loaded users"

    votesxml = Nokogiri::XML(File.open(Rails.root + "lib/importdata/votes.xml"))
    puts "Loaded votes"

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

    #
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
    guidgroups = nil

    puts "Beginning insertion of questions"
    posts = []
    versionevents = []
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
      ActiveRecord::Base.transaction do
        if qu.save
          versionevents << qu.record_create
          qu.build_tags
        end
      end
      # Iterate through each edit and apply it on top of the question
      edits.each do |edit|
        PaperTrail.whodunnit = users[edit[:user_id].to_i]
        qu.title = edit[:title] if edit[:title]
        qu.body = edit[:body] if edit[:body]
        qu.tag_list = edit[:tag_list] if edit[:tag_list]
        qu.last_active_user = users[edit[:user_id].to_i]
        qu.last_activity_at = DateTime.parse(edit[:created_at])
        qu.updated_at = DateTime.parse(edit[:created_at])
        ActiveRecord::Base.transaction do
          if qu.valid?
            versionevents << qu.record_update
            qu.save
            qu.build_tags
          end
        end
      end
      pbar.inc
      posts[q['Id'].to_i] = qu unless qu.new_record?
    end
    Tag.reset_tageh

    # Bulk import the version events
    versionevents.compact!
    versionevents.each_slice(25) do |slice|
      Version.import slice, :validate => false
    end


    versionevents = []
    #
    # Answers.
    pbar = ProgressBar.new("adding answers", answers.length)
    puts "inserting answers"
    answers.each do |a|
      an = Answer.new
      edits = groupededits[a['Id']]
      originator = edits.select { |v| v[:new_record] = true }[0]
      edits.delete originator
      PaperTrail.whodunnit = users[originator[:user_id].to_i] 
      an.question = posts[a['ParentId'].to_i]
      an.body = originator[:body]
      an.user = users[originator[:user_id].to_i]
      an.created_at = DateTime.parse(originator[:created_at])
      an.save
      versionevents << an.record_create
      edits.each do |edit|
        PaperTrail.whodunnit = users[edit[:user_id].to_i]
        an.body = edit[:body]
        an.updated_at = DateTime.parse(edit[:created_at])
        versionevents << an.record_update
      end
      posts[a['Id'].to_i] = an unless an.new_record?
      pbar.inc
    end

    versionevents.compact!
    versionevents.each_slice(25) do |slice|
      Version.import slice, :validate => false
    end

    commentsxml = Nokogiri::XML(File.open(Rails.root + "lib/importdata/comments.xml")).css('comments row')
    comments = []
    commentsxml.each do |comment|
      c = Comment.new
      c.user = users[comment['UserId'].to_i] unless comment['UserId'].blank?
      c.body = comment['Text']
      c.post = posts[comment['PostId'].to_i]
      c.created_at = DateTime.parse(comment['CreationDate'])
      comments << c
    end

    comments.compact.each_slice(50) do |slice|
      Comment.import slice
    end

    #
    # Clean up some stuff from inserting posts and comments
    comments = nil
    commentsxml = nil
    users = nil

    #
    # Votes.
    size = User.count
    users = User.all
    votes = []
    voterow = votesxml.css('votes row')
    pbar = ProgressBar.new("making votes", voterow.length)
    voterow.each do |row|
      next unless [2, 3].include? row['VoteTypeId'].to_i
      next if posts[row['PostId'].to_i].blank?
      post = posts[row['PostId'].to_i]
      vote = post.votes.new
      vote.value = 1 if row['VoteTypeId'].to_i == 2
      vote.value = -1 if row['VoteTypeId'].to_i == 3
      vote.user = users[(rand*size).floor]
      next if vote.user == post.user
      vote.created_at = DateTime.parse row['CreationDate']
      vote.updated_at = DateTime.parse row['CreationDate']
      votes << vote
      #vote.save(:validate => false)
      pbar.inc
    end


    votes.compact!
    votes.each_slice(100) do |slice|
      Vote.import slice, :validate => false
    end

    votes = Vote.all
    questions = Question.all
    answers = Answer.all
    pbar = ProgressBar.new("rep events", votes.length)
    repevents = []
    votes.each do |v|
      if v.voteable_type == "Question"
        repevents << v.return_reputation_event(questions[v.voteable_id])
      elsif v.voteable_type == "Answer"
        repevents << v.return_reputation_event(answers[v.voteable_id])
      end
      pbar.inc
    end
  
    repevents.compact!
    repevents.each_slice(100) do |slice|
      ReputationEvent.import slice, :validate => false
    end
  end
end

