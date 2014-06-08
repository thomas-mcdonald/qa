require 'spec_helper'
require 'concerns/voteable_examples'

describe Question, :type => :model do
  it_should_behave_like 'voteable'

  context 'associations' do
    it { is_expected.to have_many(:answers) }
    it { is_expected.to have_many(:taggings) }
    it { is_expected.to have_many(:tags) }
    it { is_expected.to belong_to(:user) }
  end

  [:body, :last_active_user_id, :last_active_at, :title].each do |attr|
    it { is_expected.to validate_presence_of(attr) }
  end
  it { is_expected.to ensure_length_of(:title).is_at_least(10).is_at_most(150) }
  it { is_expected.to ensure_length_of(:body).is_at_least(10).is_at_most(30000) }

  context 'accepted_is_on_question' do
    it 'does not add an error if there is no accepted_answer_id' do
      question = FactoryGirl.build(:question, accepted_answer_id: nil)
      expect(question).to be_valid
    end

    it 'is valid if the answer id is an answer to the question' do
      answer = FactoryGirl.create(:answer)
      question = answer.question
      question.accepted_answer_id = answer.id
      expect(question).to be_valid
    end

    it 'is not valid if the answer id is not an answer to the question' do
      question = FactoryGirl.build(:question, accepted_answer_id: 1)
      expect(question).not_to be_valid

      question = FactoryGirl.build(:question, accepted_answer_id: 'string')
      expect(question).not_to be_valid
    end
  end

  context '#update_last_activity' do
    let(:question) { FactoryGirl.build(:question) }
    let(:user) { FactoryGirl.create(:user) }

    before { question.update_last_activity(user) }

    skip 'implement time based tests with Rails travel_to'
  end

  context 'votes_on_self_and_answers_by_user' do
    let(:answer) { FactoryGirl.create(:answer) }
    let(:question) { answer.question }
    let(:user) { FactoryGirl.create(:user) }

    it 'returns an empty array if user is nil' do
      expect(question.votes_on_self_and_answers_by_user(nil)).to eq([])
    end

    it 'returns votes on self by user if no answers are present' do
      vote = FactoryGirl.create(:upvote, user: user)
      question.votes << vote

      expect(question.votes_on_self_and_answers_by_user(user)).to eq([vote])
    end

    it 'returns votes on self and answers by user' do
      question.votes << FactoryGirl.create(:upvote, user: user)
      answer.votes << FactoryGirl.create(:upvote, user: user)

      expect(question.votes_on_self_and_answers_by_user(user)).to include(question.votes.first)
      expect(question.votes_on_self_and_answers_by_user(user)).to include(answer.votes.first)
    end
  end

  context '.tagged_with' do
    it 'raises an error if the tag does not exist' do
      expect { Question.tagged_with('nope') }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns questions tagged with that tag' do
      q1 = FactoryGirl.create(:question, tag_list: 'tagger')
      q2 = FactoryGirl.create(:question, tag_list: 'tag')
      q3 = FactoryGirl.create(:question, tag_list: 'tagger, tag')
      res = Question.tagged_with('tagger')
      expect(res).to include(q1)
      expect(res).to include(q3)
      expect(res).not_to include(q2)
    end
  end
end
