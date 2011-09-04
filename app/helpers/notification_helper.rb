module NotificationHelper  
  def notibox(notification, klass = 'info', &block)
    content = capture(&block)
    "<div class='alert-message #{klass}' id='notification-#{notification.id}'>#{ link_to "x", dismiss_notification_url(notification), :remote => true, :class => :close }<p>#{content}</p></div>".html_safe
  end
  
  def new_answer(notification)
    notibox notification do
      notification.parameters[:link] = link_to notification.parameters[:title], question_url(notification.parameters[:id])
      I18n.t("notifications.#{notification.token}", notification.parameters).html_safe
    end
  end
end
