require 'spec_helper'
require 'vote_creator'

describe VoteCreator do
  let(:post) { FactoryGirl.create(:question) }
  let(:answer) { FactoryGirl.create(:answer) }
  let(:user) { FactoryGirl.create(:user) }

  it 'requires a non-nil user object' do
    -> { VoteCreator.new(nil, {}) }.should raise_error(ArgumentError)
  end

  it 'requires some other non-nil parameters' do
    -> { VoteCreator.new(user, post_id: nil, post_type: 'Question', vote_type: 'upvote') }.should raise_error(ArgumentError)
    -> { VoteCreator.new(user, post_id: 1, post_type: 'Question', vote_type: nil) }.should raise_error(ArgumentError)
    -> { VoteCreator.new(user, post_id: 1, post_type: nil, vote_type: 'upvote') }.should raise_error(ArgumentError)
  end

  it 'returns the vote when create is called' do
    vote = VoteCreator.new(user, post_id: post.id, post_type: 'Question', vote_type: 'upvote')
    vote.create.should be_a(Vote)
  end

  it 'queues answer_vote processing if needed' do
    expect {
      VoteCreator.new(user, post_id: answer.id, post_type: 'Answer', vote_type: 'upvote').create
    }.to change(Jobs::Badges::AnswerVote.jobs, :size).by(1)

    expect {
      VoteCreator.new(user, post_id: answer.id, post_type: 'Answer', vote_type: 'downvote').create
    }.to change(Jobs::Badges::AnswerVote.jobs, :size).by(1)

    expect {
      VoteCreator.new(user, post_id: post.id, post_type: 'Question', vote_type: 'upvote').create
    }.to_not change(Jobs::Badges::AnswerVote.jobs, :size)
  end

  describe '#create_reputation_events' do
    context 'on a question vote' do
      it 'creates a reputation event with the correct type' do
        vote = VoteCreator.create(user, post_id: post.id, post_type: 'Question', vote_type: 'upvote')
        re = ReputationEvent.where(action: vote).first
        re.event_type.should == 'receive_question_upvote'
      end
    end
  end
end
