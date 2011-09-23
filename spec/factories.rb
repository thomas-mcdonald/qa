Factory.define(:user) do |u|
  u.username { Factory.next :username }
  u.email { Factory.next :email }
  u.password "secret"
  u.password_confirmation "secret"
end

Factory.define(:question) do |q|
  q.title "What is this I don't even?"
  q.body "I do not understand why it is doing this, it should be doing this but it is doing that"
  q.tag_list "tag, example"
  q.association :user
end

Factory.define(:answer) do |a|
  a.body "This is most likely the answer to your issue."
  a.association :user
  a.association :question
end

Factory.define(:reputation_event) do |r|
  r.reputable { Factory(:vote) }
  r.user { Factory(:user) }
  r.value 1
end

Factory.define(:vote) do |v|
  v.user { Factory(:user) }
  v.voteable { Factory(:question) }
  v.value 1
end

Factory.define(:flag) do |f|
  f.reason "spam"
  f.user { Factory(:user) }
  f.flaggable { Factory(:question) }
end

Factory.define(:tag) do |t|
  t.name "Example"
end

Factory.define(:tagging) do |t|
  t.question { Factory(:question) }
  t.tag { Factory(:tag) }
end

Factory.define(:badge) do |b|
  b.token "student"
  b.user { Factory(:user) }
end

Factory.sequence(:username) do |n|
  "tom-#{n}"
end

Factory.sequence(:email) do |n|
  "example-#{n}@example.com"
end
