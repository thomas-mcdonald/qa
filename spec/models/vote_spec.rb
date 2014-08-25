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

  describe '#locked?' do
    it 'is not locked if the post is recently changed' do
      # new posts so obviously not changed
      vote = FactoryGirl.create(:upvote)
      expect(vote.locked?).to be(false)
    end

    it 'is locked if it is an old vote on an unchanged post' do
      vote = FactoryGirl.create(:upvote)
      travel(3.days)
      expect(vote.locked?).to be(true)
    end

    it 'is not locked if the post changed after the vote' do
      vote = FactoryGirl.create(:upvote)
      travel(7.days)
      vote.post.stubs(:last_active_at).returns(6.days.ago)
      expect(vote.locked?).to be(false)
    end
  end
end
