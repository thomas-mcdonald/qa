module UrlHelper
  def login_link(text, id = nil)
    link_to text, '#', 'data-toggle': 'modal', 'data-target': '#login-modal', id: id
  end
end
