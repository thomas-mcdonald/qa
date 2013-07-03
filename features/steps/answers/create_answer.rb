class Spinach::Features::CreateAnswer < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedQuestion

  step 'I submit the answer form with a valid answer' do
    fill_in 'answer_body', with: 'This is my answer to the question'
    find(:xpath, '//input[@name="commit"]').click
  end

  step 'I should see the answer' do
    current_path.should == question_path(current_question)
    should have_content 'This is my answer to the question'
  end
end