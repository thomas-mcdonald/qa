FactoryGirl.define do
  sequence(:email) { |n| "person#{n}@example.com" }

  factory :authorization do
    provider  'faux'
    uid       '12345'
    email     # Uses email sequence
  end

  factory :user do
    name  'John Smith'
    email # Uses email sequence
  end

  factory :question do
    association :last_active_user, factory: :user
    title 'How do I aaaaa'
    body 'What is the best way'
    last_active_at DateTime.current
    tag_list 'example-tag, multiple'
    user
  end

  factory :answer do
    body 'answer on how to do it'
    question
    user
  end

  factory :tag do
    name 'example-tag'
  end

  factory :upvote, class: Vote do
    association :post, factory: :question
    user
    vote_type 'upvote'
  end

  factory :downvote, class: Vote do
    association :post, factory: :question
    user
    vote_type 'downvote'
  end

  factory :comment do
    association :post, factory: :question
    user
    body 'This is an example comment'
  end
end