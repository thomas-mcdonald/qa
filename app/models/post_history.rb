class PostHistory < ActiveRecord::Base
  belongs_to :timeline_event

  def render_body
    Pipeline.generic_render(body)
  end
end
