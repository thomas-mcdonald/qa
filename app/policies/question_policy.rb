class QuestionPolicy
  attr_reader :user, :question

  def initialize(user, question)
    @user = user
    @question = question
  end

  def edit?
    user && user.reputation >= ReputationRequirements.question.edit
  end

  def update?
    edit?
  end
end