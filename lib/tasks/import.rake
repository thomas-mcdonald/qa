namespace :import do
  task :all => :environment do
    Rake::Task["db:reset"].invoke
    
    f = File.open(File.join(Rails.root + "lib/importdata/users.xml"))
    doc = Nokogiri::XML(f)
    n = 0
    users = []
    doc.css('users row').select{|u| u['Id'] != -1.to_s}.each do |user|
      n += 1
      u = User.new(
        :username => user['DisplayName'].gsub(/[^0-9a-zA-Z@_\.]/, '') + n.to_s,
        :display_name => user['DisplayName'],
        :about_me => user['AboutMe'],
        :email => "example-#{n}@example.com"
      )
      u.created_at = Date.parse(user['CreationDate'])
      u.password_hash = "$2a$10$GNApXWcXPJ2ro5vgwMyo1.yGldKMZJcJnkDPXBoVNNpeF4Z2KBlpW"
      u.password_salt = "$2a$10$GNApXWcXPJ2ro5vgwMyo1."
      # :password => "randompassword",
      users[user['Id'].to_i] = u
      u.save(:validate => false)
      print "."
    end
    puts "\n-- \n -- inserted #{n} users \n --"

    # Questions and answers
    Question.delete_all
    Answer.delete_all
    f = File.open(File.join(Rails.root + "lib/importdata/posts.xml"))
    doc = Nokogiri::XML(f)
    posts = []
    n = 0
    questions = []
    answers = []
    doc.css('posts row').each do |post|
      if post['PostTypeId'].to_i == 1
        questions << post
      elsif post['PostTypeId'].to_i == 2
        answers << post
      end
    end
    questions.each do |post|
      n += 1
      user_id = users[post['OwnerUserId'].to_i] ? users[post['OwnerUserId'].to_i].id : 0
      q = Question.new(
        :title => post['Title'],
        :body => post['Body'],
        :user_id => user_id,
        :tag_list => post['Tags'].split("><").each { |t| t.gsub!(/[<>]/, "") }.join(",") # Elegant solutions ftw
      )
      q.created_at = Date.parse(post['CreationDate'])
      posts[post['Id'].to_i] = q
      q.save
      print "."
    end
    answers.each do |post|
      n += 1
      if posts[post['ParentId'].to_i] == nil
        puts post['ParentId']
        puts post['Id']
      end
      user_id = users[post['OwnerUserId'].to_i] ? users[post['OwnerUserId'].to_i].id : 0
      a = posts[post['ParentId'].to_i].answers.new(
        :body => post['Body'],
        :user_id => user_id
      )
      a.created_at = Date.parse(post['CreationDate'])
      posts[post['Id'].to_i] = a
      a.save
      print "."
    end
    puts posts.size
    puts "\n-- \n inserted #{n} posts \n --"

    n = 0
    users = User.count
    Question.all.each do |q|
      (rand*15).floor.times do
        q.votes.new(
          :user => User.offset((rand*users).ceil).first,
          :value => 1
        ).save
        n += 1
        print "."
      end
    end
    Answer.all.each do |a|
      (rand*15).floor.times do
        a.votes.new(
          :user => User.offset((rand*users).ceil).first,
          :value => 1
        ).save
        n += 1
        print "."
      end
    end
    puts "\n -- \n inserted #{n} votes \n --"
  end
end
