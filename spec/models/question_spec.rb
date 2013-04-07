require 'spec_helper'
require 'concerns/voteable_examples'

describe Question do
  it { should have_many(:answers) }
  it { should have_many(:taggings) }
  it { should have_many(:tags) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:title).is_at_least(10).is_at_most(150) }

  it_should_behave_like 'voteable'

  context 'votes_on_self_and_answers_by_user' do
    let(:answer) { FactoryGirl.create(:answer) }
    let(:question) { answer.question }
    let(:user) { FactoryGirl.create(:user) }

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

  context '.tagged_with' do
    it 'raises an error if the tag does not exist' do
      -> { Question.tagged_with('nope') }.should raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns questions tagged with that tag' do
      q1 = FactoryGirl.create(:question, tag_list: 'tagger')
      q2 = FactoryGirl.create(:question, tag_list: 'tag')
      q3 = FactoryGirl.create(:question, tag_list: 'tagger, tag')
      res = Question.tagged_with('tagger')
      res.should include(q1)
      res.should include(q3)
      res.should_not include(q2)
    end
  end
end