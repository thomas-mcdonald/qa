FactoryGirl.define do
  factory :user do
    username { generate :username }
    email { generate :email }
    password "secret"
    password_confirmation "secret"
  end

  factory :question do
    title "What is this I don't even?"
    body "I do not understand why it is doing this, it should be doing this but it is doing that"
    tag_list "tag, example"
    association :user
  end

  factory :answer do
    body "This is most likely the answer to your issue."
    association :user
    association :question
  end

  factory :reputation_event do
    association :reputable, factory: :vote
    user
    value 1
  end

  factory :vote do
    user
    association :voteable, factory: :question
    value 1
  end

  factory :flag do
    reason "spam"
    user
    association :flaggable, factory: :question
  end

  factory :tag do
    name "Example"
  end

  factory :tagging do
    question
    tag
  end

  factory :badge do
    token "student"
    user
  end

  factory :notification do
    token 'new_answer'
    user
  end

  # Sequences

  sequence(:username) do |n|
    "tom-#{n}"
  end

  sequence(:email) do |n|
    "example-#{n}@example.com"
  end
end