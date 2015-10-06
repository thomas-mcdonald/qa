module TabHelper
  def tab_tag(name)
    link_class = @active_tab == name ? 'active' : nil

    content_tag(:li, class: link_class) do
      yield
    end
  end
end