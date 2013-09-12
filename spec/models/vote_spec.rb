require 'spec_helper'

def event_type(type, vote)
  Vote.new(post_type: type, vote_type_id: vote).event_type
end

describe Vote do
  context 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:user) }
  end

  context '#event_type' do
    it 'returns the correct event type for the post and vote' do
      event_type('question', Vote::UPVOTE).should == 'question_upvote'
      event_type('question', Vote::DOWNVOTE).should == 'question_downvote'
      event_type('answer', Vote::UPVOTE).should == 'answer_upvote'
      event_type('answer', Vote::DOWNVOTE).should == 'answer_downvote'
    end
  end
end