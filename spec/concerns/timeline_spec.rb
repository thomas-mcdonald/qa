require 'spec_helper'
require 'timeline'

describe QA::Timeline do
  let(:user) { FactoryGirl.create(:user) }

  describe '#create_timeline_event!' do
    it 'provides a thin wrapper to TimelineEvent' do
      TimelineEvent.should_receive(:on_post_create)
      post = Question.new
      post.create_timeline_event!
    end
  end

  describe '#edit_timeline_event!' do
    it 'provides a wrapper to TimelineEvent' do
      TimelineEvent.should_receive(:on_post_edit)
      post = Question.new
      post.edit_timeline_event!(user)
    end
  end
end