class Spinach::Features::AcceptAnswer < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths

  step 'there exists a question with an accepted answer' do
    @answer = create(:answer)
    @answer.question.accepted_answer_id = @answer.id
    @answer.question.save
  end

  step 'I asked a question with an answer' do
    @question = create(:question, user: current_user)
    @answer = create(:answer, question: @question)
  end

  step 'I click on the accept answer button' do
    find(%(#{answer_css} .accept-answer button)).click
  end

  step 'I should see it become active' do
    within(%(#{answer_css} .accept-answer button)) do
      should have_css '.icon-ok.active'
    end
  end

  step 'I see an indication of the accepted answer' do
    within(answer_css) { should have_css('.icon-ok.active') }
  end

  def current_question
    @answer.question
  end

  private

  # The CSS selector we can use to return the answer
  def answer_css
    %(#answer-#{@answer.id})
  end
end