module SharedPolicy
  def logged_in?
    user
  end

  def staff?
    user.staff?
  end
end
