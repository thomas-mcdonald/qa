module ApplicationHelper
  def active_tab(opts, &block)
    if params.merge(opts) == params
      %(<li class="active">#{capture(&block)}</li>).html_safe
    else
      %(<li>#{capture(&block)}</li>).html_safe
    end
  end
end
