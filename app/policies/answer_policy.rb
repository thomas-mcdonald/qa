class AnswerPolicy
  attr_reader :user, :answer

  def initialize(user, answer)
    @user = user
    @answer = answer
  end

  def edit?
    user && user.reputation >= ReputationRequirements.answer.edit
  end

  def update?
    edit?
  end
end