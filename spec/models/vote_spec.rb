require 'spec_helper'

describe Vote do
  context 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:user) }
  end

  context '#create_reputation_events' do
    context 'on a question vote' do
      let(:question) { FactoryGirl.create(:question) }

      it 'creates a reputation event with the correct type' do
        vote = FactoryGirl.build(:upvote, post: question)
        vote.create_reputation_events
        re = ReputationEvent.where(action: vote).first
        re.event_type.should == 1
      end
    end
  end
end