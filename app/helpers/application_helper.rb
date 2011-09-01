require "digest/md5"

module ApplicationHelper
  def gravatar(email, size = 80)
    hash = Digest::MD5.hexdigest(email)
    image_tag "http://www.gravatar.com/avatar/#{hash}?s=#{size}"
  end
end

class String
  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(self).html_safe
  end
end
