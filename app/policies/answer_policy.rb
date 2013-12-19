class AnswerPolicy
  attr_reader :user, :answer

  def initialize(user, answer)
    @user = user
    @answer = answer
  end

  def edit?
    user && user.reputation >= 1000
  end

  def update?
    edit?
  end
end