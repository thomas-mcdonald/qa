require 'spec_helper'
require 'concerns/voteable_examples'

describe Answer, type: :model do
  it_should_behave_like 'voteable'

  describe 'associations' do
    it { is_expected.to have_many(:comments) }
    it { is_expected.to belong_to(:question) }
    it { is_expected.to have_many(:timeline_events) }
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    [:question_id, :user_id].each do |attr|
      it { is_expected.to validate_presence_of(attr) }
    end
    it { is_expected.to ensure_length_of(:body).is_at_least(10).is_at_most(30000) }
  end

  describe '#question_view_ordering' do
    let(:question) { FactoryGirl.create(:question, accepted_answer_id: nil) }
    let(:a1) { FactoryGirl.create(:answer, question: question) }
    let(:a2) { FactoryGirl.create(:answer, question: question) }

    before do
      # create an upvote on a2
      VoteCreator.new(FactoryGirl.create(:user), post_id: a2.id, post_type: 'Answer', vote_type: 'upvote').create
    end

    it 'orders by vote as per usual if there is no accepted answer' do
      expect(question.answers.question_view_ordering(question)).to eq([a2, a1])
    end

    it 'pulls out the accepted answer first if there is an accept answer' do
      question.accepted_answer_id = a1.id
      question.save
      expect(question.answers.question_view_ordering(question)).to eq([a1, a2])
    end
  end
end
