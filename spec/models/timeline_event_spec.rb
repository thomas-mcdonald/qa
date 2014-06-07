require 'spec_helper'

describe TimelineEvent, :type => :model do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  describe 'associations' do
    it { is_expected.to belong_to(:post) }
  end

  describe '#on_post_create' do
    it 'creates models as appropriate' do
      event = TimelineEvent.on_post_create(question, user)
      expect(event.timeline_actors.size).to eq(1)
      expect(event.timeline_actors.first.user).to eq(user)
      expect(event.action).to eq('post_create')
    end
  end

  describe '#on_post_edit' do
    it 'creates a timeline event' do
      event = TimelineEvent.on_post_edit(question, user)
      expect(event.timeline_actors.size).to eq(1)
      expect(event.timeline_actors.first.user).to eq(user)
      expect(event.action).to eq('post_edit')
    end
  end
end