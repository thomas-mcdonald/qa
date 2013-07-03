module SharedQuestion
  include Spinach::DSL

  step 'there exists a question' do
    @question = create(:question)
  end
  
  step 'I have asked a question' do
    @question = create(:question, user: current_user)
  end

  def current_question
    @question ||= Question.first
  end
end