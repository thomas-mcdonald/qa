require 'spec_helper'
require 'timeline'

describe QA::Timeline do
  class Post
    include QA::Timeline
  end

  let(:user) { FactoryGirl.create(:user) }

  context '#create_timeline_event' do
    it 'works' do
      TimelineEvent.should_receive(:on_post_create)
      post = Post.new
      post.create_timeline_event(user)
    end
  end
end