module SharedPolicy
  def staff
    user.staff?
  end
end
