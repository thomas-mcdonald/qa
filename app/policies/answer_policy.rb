class AnswerPolicy
  include SharedPolicy

  attr_reader :user, :answer

  def initialize(user, answer)
    @user = user
    @answer = answer
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

  def edit_reputation
    user.reputation >= ReputationRequirements.answer.edit
  end
end
