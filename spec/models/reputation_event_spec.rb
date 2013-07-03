require 'spec_helper'

describe ReputationEvent do
  context '.create_on_receive_vote' do
    it 'has the correct event_type' do
      vote = FactoryGirl.build(:upvote)
      r = ReputationEvent.create_on_receive_vote(vote)
      r.event_type.should == ReputationEvent::QUESTION_UPVOTE
      r.user_id.should == vote.post.user_id
    end
  end
end
