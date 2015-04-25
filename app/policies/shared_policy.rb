module SharedPolicy
  delegate :staff?, to: :user

  def logged_in?
    user
  end
end
