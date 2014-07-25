class PostPolicy
  include SharedPolicy

  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def edit?
    logged_in && (edit_reputation || staff)
  end

  def update?
    edit?
  end

  private

  def logged_in
    user
  end
end
