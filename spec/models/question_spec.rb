require 'spec_helper'
require 'concerns/voteable_examples'

describe Question do
  it_should_behave_like 'voteable'

  context 'associations' do
    it { should have_many(:answers) }
    it { should have_many(:taggings) }
    it { should have_many(:tags) }
    it { should belong_to(:user) }
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:title).is_at_least(10).is_at_most(150) }
  it { should ensure_length_of(:body).is_at_least(10).is_at_most(30000) }

  context 'accepted_is_on_question' do
    it 'does not add an error if there is no accepted_answer_id' do
      question = FactoryGirl.build(:question, accepted_answer_id: nil)
      question.should be_valid
    end

    it 'is valid if the answer id is an answer to the question' do
      answer = FactoryGirl.create(:answer)
      question = answer.question
      question.accepted_answer_id = answer.id
      question.should be_valid
    end

    it 'is not valid if the answer id is not an answer to the question' do
      question = FactoryGirl.build(:question, accepted_answer_id: 1)
      question.should_not be_valid

      question = FactoryGirl.build(:question, accepted_answer_id: 'string')
      question.should_not be_valid
    end
  end

  context '#update_last_activity' do
    let(:question) { FactoryGirl.build(:question) }
    let(:user) { FactoryGirl.create(:user) }

    before { question.update_last_activity(user) }

    pending 'look into Timecop for testing time updates'
  end

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
