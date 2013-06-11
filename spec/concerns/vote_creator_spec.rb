require 'spec_helper'

require 'vote_creator'

describe VoteCreator do
  let(:post) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  it 'requires a non-nil user object' do
    -> { VoteCreator.new(nil, {}) }.should raise_error(ArgumentError)
  end

  it 'requires some other non-nil parameters' do
    -> { VoteCreator.new(user, post_id: nil, post_type: 'Question', vote_type_id: 1) }.should raise_error(ArgumentError)
    -> { VoteCreator.new(user, post_id: 1, post_type: 'Question', vote_type_id: nil) }.should raise_error(ArgumentError)
    -> { VoteCreator.new(user, post_id: 1, post_type: nil, vote_type_id: 1) }.should raise_error(ArgumentError)
  end

  it 'returns the vote when create is called' do
    vote = VoteCreator.new(user, post_id: post.id, post_type: 'Question', vote_type_id: 1)
    vote.create.should be_a(Vote)
  end

  context '#create_reputation_events' do
    context 'on a question vote' do
      it 'creates a reputation event with the correct type' do
        vote_creator = VoteCreator.new(user, post_id: post.id, post_type: 'Question', vote_type_id: 1)
        vote = vote_creator.create_vote
        vote_creator.create_reputation_events
        re = ReputationEvent.where(action: vote).first
        re.event_type.should == 1
      end
    end
  end
end