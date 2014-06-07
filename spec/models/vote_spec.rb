require 'spec_helper'

def event_type(type, vote)
  Vote.new(post_type: type, vote_type: vote).event_type
end

describe Vote, :type => :model do
  context 'associations' do
    it { is_expected.to belong_to(:post) }
    it { is_expected.to belong_to(:user) }
  end

  context '#event_type' do
    it 'returns the correct event type for the post and vote' do
      expect(event_type('question', Vote.types['upvote'])).to eq('question_upvote')
      expect(event_type('question', Vote.types['downvote'])).to eq('question_downvote')
      expect(event_type('answer', Vote.types['upvote'])).to eq('answer_upvote')
      expect(event_type('answer', Vote.types['downvote'])).to eq('answer_downvote')
    end
  end
end