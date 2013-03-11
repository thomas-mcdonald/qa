require 'spec_helper'
require 'concerns/voteable_examples'

describe Question do
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:title).is_at_least(10).is_at_most(150) }

  it_should_behave_like 'voteable'

  context 'votes_on_self_and_answers_by_user' do
    let(:answer) { FactoryGirl.create(:answer) }
    let(:question) { answer.question }
    let(:user) { answer.user }

    it 'returns an empty array if user is nil' do
      question.votes_on_self_and_answers_by_user(nil).should == []
    end

    it 'returns votes on self by user if no answers are present' do
      vote = FactoryGirl.create(:upvote, user: user)
      question.votes << vote

      question.votes_on_self_and_answers_by_user(user).should == [vote]
    end

    it 'returns votes on self and answers by user' do
      question.votes << FactoryGirl.create(:upvote, user: user)
      answer.votes << FactoryGirl.create(:upvote, user: user)

      question.votes_on_self_and_answers_by_user(user).should include(question.votes.first)
      question.votes_on_self_and_answers_by_user(user).should include(answer.votes.first)
    end
  end
end