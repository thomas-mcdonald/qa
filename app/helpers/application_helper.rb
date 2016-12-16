module ApplicationHelper
  def active_tab(opts, &block)
    if params.merge(opts) == params
      %(<li class="active">#{capture(&block)}</li>).html_safe
    else
      %(<li>#{capture(&block)}</li>).html_safe
    end
  end

  def navbar_link(text, link)
    link_to(text, link, class: 'pt-button pt-minimal')
  end
end
