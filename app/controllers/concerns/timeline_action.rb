module TimelineAction
  extend ActiveSupport::Concern

  included do
    before_action :load_timeline_post, only: :timeline
  end

  def timeline
    @timeline_events = @post.timeline_events.includes(:post_history, :timeline_actors).order('created_at DESC')
    render 'posts/timeline'
  end
end
