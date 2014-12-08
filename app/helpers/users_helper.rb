module UsersHelper
  def can_view_users_email?(user)
    logged_in? && (is_user(user) || current_user.staff?)
  end

  # Pluralizes the string based off count.
  # Wraps the count in a span to style it differently
  def header_pluralize(count, singular, plural)
    word = if count == 1 then singular else plural end
    "<span>#{count}</span> #{word}".html_safe
  end
end
