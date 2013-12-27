class QuestionPolicy
  attr_reader :user, :question

  def initialize(user, question)
    @user = user
    @question = question
  end

  def edit?
    user && user.reputation >= 1000
  end

  def update?
    edit?
  end
end