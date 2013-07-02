class Spinach::Features::EditAnswer < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedQuestion

  step 'there exists a question with an answer' do
    @answer = FactoryGirl.create(:answer)
    @question = @answer.question
  end

  step 'I cannot see a link to edit the answer' do
    within('.answer .links') { should_not have_content('edit') }
  end

  step 'I can see a link to edit the answer' do
    within('.answer .links') { should have_content('edit') }
  end

  step 'I fill out the form with updated answer information' do
    fill_in 'answer_body', with: 'Actually, I believe the answer should be more like this'
  end

  step 'I click on the submit button' do
    find(:xpath, '//input[@name="commit"]').click
  end

  step 'I am on the question page' do
    current_path.should == question_path(current_question)
  end

  step 'I can see the updated answer' do
    should have_content 'Actually, I believe the answer should be more like this'
  end

  def current_answer
    @answer
  end
end