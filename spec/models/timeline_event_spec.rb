require 'spec_helper'

describe TimelineEvent do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  context 'associations' do
    it { should belong_to(:post) }
  end

  context '#on_post_create' do
    it 'creates models as appropriate' do
      event = TimelineEvent.on_post_create(question, user)
      event.timeline_actors.size.should == 1
      event.timeline_actors.first.user.should == user
    end
  end
end