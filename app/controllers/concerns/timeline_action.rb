module TimelineAction
  extend ActiveSupport::Concern

  included do
    before_filter :load_timeline_post, only: :timeline
  end

  def timeline
    render 'posts/timeline'
  end
end