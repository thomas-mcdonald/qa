require 'spec_helper'

def rep_event_type(type, vote)
  Vote.new(post_type: type, vote_type_id: vote).reputation_event_type
end

describe Vote do
  context 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:user) }
  end

  context '#reputation_event_type' do
    it 'returns the correct event type for the post and vote' do
      rep_event_type('question', Vote::UPVOTE).should == ReputationEvent::QUESTION_UPVOTE
      rep_event_type('question', Vote::DOWNVOTE).should == ReputationEvent::QUESTION_DOWNVOTE
      rep_event_type('answer', Vote::UPVOTE).should == ReputationEvent::ANSWER_UPVOTE
      rep_event_type('answer', Vote::DOWNVOTE).should == ReputationEvent::ANSWER_DOWNVOTE
    end
  end
end