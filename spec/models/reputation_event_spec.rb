require 'spec_helper'

describe ReputationEvent do
  context '.create_for_receiving_question_upvote' do
    it 'has the correct event_type' do
      vote = FactoryGirl.build(:upvote)
      r = ReputationEvent.create_for_receiving_question_upvote(vote)
      r.event_type.should == 1
    end
  end
end
