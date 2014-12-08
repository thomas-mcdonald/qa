module QuestionsHelper
  def format(text)
    Pipeline.generic_render(text)
  end

  def format_body(post)
    Rails.cache.fetch("post:v1:rendered_body:#{post.cache_key}", expires_in: 5.minutes) do
      format(post.body)
    end
  end
end
