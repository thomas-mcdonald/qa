class QuestionPolicy < PostPolicy
  def edit_reputation
    user.reputation >= ReputationRequirements.question.edit
  end
end
