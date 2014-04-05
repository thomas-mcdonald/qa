require 'spec_helper'

describe ReputationEvent do
  context '.create_on_receive_vote' do
    it 'has the correct event_type and user id' do
      vote = FactoryGirl.build(:upvote)
      r = ReputationEvent.create_on_receive_vote(vote)
      r.event_type.should == 'receive_question_upvote'
      r.user_id.should == vote.post.user_id
    end
  end

  context '.create_on_give_vote' do
    it 'has the correct event type and user id' do
      vote = FactoryGirl.build(:upvote)
      r = ReputationEvent.create_on_give_vote(vote)
      r.event_type.should == 'give_question_upvote'
      r.user_id.should == vote.user_id
    end
  end
end
