require "digest/md5"

module ApplicationHelper
  def pluralize_count(count, singular, plural = nil)
    ("<div class='num'>#{count || 0}</div><div>" + ((count == 1 || count =~ /^1(\.0+)?$/) ? singular : (plural || singular.pluralize)) + "</div>").html_safe
  end
  
  def gravatar(email, size = 80)
    hash = Digest::MD5.hexdigest(email)
    image_tag "http://www.gravatar.com/avatar/#{hash}?s=#{size}"
  end

  def diff_tag_link(hash)
    tlink = link_to hash[:tag], tagged_questions_url(hash[:tag]), :class => "btn tag"
    tlink = %Q[<del class="differ">#{tlink.html_safe}</del>] if hash[:remove]
    tlink = %Q[<ins class="differ">#{tlink.html_safe}</ins>] if hash[:insert]
    tlink.html_safe
  end

  def format(string)
    QA::TextParser.new(string).format
  end
end
