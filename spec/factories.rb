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
    title 'How do I aaaaa'
    body 'What is the best way'
    user
  end

  factory :answer do
    body 'answer on how to do it'
    question
    user
  end

  factory :upvote, class: Vote do
    association :post, factory: :question
    user
    vote_type_id 1
  end

  factory :downvote, class: Vote do
    association :post, factory: :question
    user
    vote_type_id 2
  end
end