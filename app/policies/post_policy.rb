class PostPolicy
  include SharedPolicy

  attr_reader :user, :post

  def initialize(user, post)
    @user = user
    @post = post
  end

  def edit?
    logged_in? && (edit_reputation || staff? || is_users)
  end

  def update?
    edit?
  end

  private

  def is_users
    post.user_id == user.id
  end
end
