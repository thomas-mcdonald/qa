require 'spec_helper'

describe TimelineEvent do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'associations' do
    it { should belong_to(:post) }
  end

  describe '#on_post_create' do
    it 'creates models as appropriate' do
      event = TimelineEvent.on_post_create(question, user)
      event.timeline_actors.size.should == 1
      event.timeline_actors.first.user.should == user
      event.action.should == 'post_create'
    end
  end

  describe '#on_post_edit' do
    it 'creates a timeline event' do
      event = TimelineEvent.on_post_edit(question, user)
      event.timeline_actors.size.should == 1
      event.timeline_actors.first.user.should == user
      event.action.should == 'post_edit'
    end
  end
end