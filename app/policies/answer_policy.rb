class AnswerPolicy < PostPolicy
  def edit_reputation
    user.reputation >= ReputationRequirements.answer.edit
  end
end
