class Spinach::Features::CreateAnswer < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedQuestion

  step 'I fill in the answer form' do
    fill_in 'answer_body', with: 'This is my answer to the question'
  end

  step 'I click on the submit button' do
    find(:xpath, '//input[@name="commit"]').click
  end

  step 'I am on the question page' do
    current_path.should == question_path(current_question)
  end

  step 'I should see the answer' do
    should have_content 'This is my answer to the question'
  end
end