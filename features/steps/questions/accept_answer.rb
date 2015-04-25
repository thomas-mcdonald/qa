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

  step 'I asked a question with an accepted answer' do
    @question = create(:question, user: current_user)
    @answer = create(:answer, question: @question)
    @question.accept_answer(@answer); @question.save
  end

  step 'I click on the accept answer button' do
    find(accept_answer_button).click
  end

  step 'I click on the unaccept answer button' do
    find(unaccept_answer_button).click
  end

  step 'I should see it become active' do
    within(unaccept_answer_button) do
      assert has_css?('.icon-ok.active')
    end
  end

  step 'I should see it become inactive' do
    within(accept_answer_button) do
      assert has_css?('.icon-ok.inactive')
    end
  end

  step 'I see an indication of the accepted answer' do
    within(answer_css) do
      assert has_css?('.icon-ok.active')
    end
  end

  def current_question
    @answer.question
  end

  private

  def accept_answer_button
    %(#{answer_css} .accept-answer button)
  end

  def unaccept_answer_button
    %(#{answer_css} .unaccept-answer button)
  end

  # The CSS selector we can use to return the answer
  def answer_css
    %(#answer-#{@answer.id})
  end
end
