module UsersHelper
  def can_view_users_email?(user)
    logged_in? && (is_user(user) || current_user.staff?)
  end
end
