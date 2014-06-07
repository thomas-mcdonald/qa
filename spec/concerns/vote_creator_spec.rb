require 'spec_helper'
require 'vote_creator'

describe VoteCreator do
  let(:post) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  it 'requires a non-nil user object' do
    expect { VoteCreator.new(nil, {}) }.to raise_error(ArgumentError)
  end

  it 'requires some other non-nil parameters' do
    expect { VoteCreator.new(user, post_id: nil, post_type: 'Question', vote_type: 'upvote') }.to raise_error(ArgumentError)
    expect { VoteCreator.new(user, post_id: 1, post_type: 'Question', vote_type: nil) }.to raise_error(ArgumentError)
    expect { VoteCreator.new(user, post_id: 1, post_type: nil, vote_type: 'upvote') }.to raise_error(ArgumentError)
  end

  it 'returns the vote when create is called' do
    vote = VoteCreator.new(user, post_id: post.id, post_type: 'Question', vote_type: 'upvote')
    expect(vote.create).to be_a(Vote)
  end

  context '#create_reputation_events' do
    context 'on a question vote' do
      it 'creates a reputation event with the correct type' do
        vote = VoteCreator.create(user, post_id: post.id, post_type: 'Question', vote_type: 'upvote')
        re = ReputationEvent.where(action: vote).first
        expect(re.event_type).to eq('receive_question_upvote')
      end
    end
  end
end