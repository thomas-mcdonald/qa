require 'spec_helper'
require 'timeline'

describe QA::Timeline do
  let(:user) { FactoryGirl.create(:user) }

  context '#create_timeline_event' do
    it 'works' do
      TimelineEvent.should_receive(:on_post_create)
      post = Question.new
      post.create_timeline_event
    end
  end
end