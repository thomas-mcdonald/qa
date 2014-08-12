class CommentPolicy
  include SharedPolicy

  attr_reader :user, :comment

  def initialize(user, comment)
    @user = user
    @comment = comment
  end

  def new?
    create?
  end

  def create?
    logged_in? && (create_reputation? || staff?)
  end

  private

  def create_reputation?
    user.reputation >= ReputationRequirements.comment.create
  end
end