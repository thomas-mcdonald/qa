require 'spec_helper'

describe ReputationEvent, type: :model do
  context '.create_on_receive_vote' do
    it 'has the correct event_type and user id' do
      vote = FactoryGirl.build(:upvote)
      r = ReputationEvent.create_on_receive_vote(vote)
      expect(r.event_type).to eq('receive_question_upvote')
      expect(r.user_id).to eq(vote.post.user_id)
    end
  end

  context '.create_on_give_vote' do
    it 'has the correct event type and user id' do
      vote = FactoryGirl.build(:upvote)
      r = ReputationEvent.create_on_give_vote(vote)
      expect(r.event_type).to eq('give_question_upvote')
      expect(r.user_id).to eq(vote.user_id)
    end
  end
end
