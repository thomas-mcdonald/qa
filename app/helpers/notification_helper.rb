module NotificationHelper  
  def notibox(notification, klass = 'info', &block)
    content = capture(&block)
    "<div class='alert-message #{klass}' id='notification-#{notification.id}'>#{ link_to "x", dismiss_notification_url(notification), :remote => true, :class => :close }<p>#{content}</p></div>".html_safe
  end
  
  def new_answer(n)
    notibox n do
      n.parameters[:link] = link_to n.parameters[:title], notification_url(n)
      I18n.t("notifications.new_answer", n.parameters).html_safe
    end
  end

  def new_badge_with_question_as_source(n)
    badge = Badge.new_from_token(n.parameters[:badge_token])
    notibox n do
      n.parameters[:badge_link] = link_to badge.name, notification_url(n)
      n.parameters[:source_link] = link_to n.parameters[:title], question_url(n.parameters[:id])
      I18n.t("notifications.new_badge_with_question_as_source", n.parameters).html_safe
    end
  end

  def new_badge_with_answer_as_source(n)
    badge = Badge.new_from_token(n.parameters[:badge_token])
    notibox n do
      n.parameters[:badge_link] = link_to badge.name, notification_url(n)
      n.parameters[:source_link] = link_to n.parameters[:question_title], question_url(n.parameters[:question_id])
      I18n.t("notifications.new_badge_with_answer_as_source", n.parameters).html_safe
    end
  end

  def new_badge_without_source(n)
    badge = Badge.new_from_token(n.parameters[:badge_token])
    notibox n do
      n.parameters[:badge_link] = link_to badge.name, notification_url(n)
      I18n.t("notifications.new_badge_without_source", n.parameters).html_safe
    end
  end
end
