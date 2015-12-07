module UrlHelper
  def badge_link(badge)
    name = badge.name.to_s.gsub('_', '-')
    link_to t(badge.badge_definition.translate_key('name')), badge_url(id: name), class: "badge #{badge.badge_type}"
  end

  def login_link(text, id = nil)
    link_to text, '#', 'data-toggle': 'modal', 'data-target': '#login-modal', id: id
  end
end
