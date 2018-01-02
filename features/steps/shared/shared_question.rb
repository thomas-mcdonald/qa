module SharedQuestion
  include Spinach::DSL

  step 'there exists a question' do
    @question = create(:question)
  end

  step 'there exists a question with an answer' do
    @answer = FactoryGirl.create(:answer)
    @question = @answer.question
  end
  
  step 'I have asked a question' do
    @question = create(:question, user: current_user)
  end

  def current_question
    @question ||= Question.first
  end
end