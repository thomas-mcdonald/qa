class QuestionPolicy
  attr_reader :user, :question

  def initialize(user, question)
    @user = user
    @question = question
  end

  def edit?
    logged_in && edit_reputation
  end

  def update?
    edit?
  end

  private

  def logged_in
    user
  end

  def edit_reputation
    user.reputation >= ReputationRequirements.question.edit
  end
end
