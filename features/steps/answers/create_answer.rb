class Spinach::Features::CreateAnswer < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedQuestion

  step 'I submit the answer form with a valid answer' do
    fill_in_form 'This is my answer to the question'
  end

  step 'I submit the answer form with an invalid answer' do
    fill_in_form 'short' # invalid - too short
  end

  step 'I should see the answer' do
    assert_equal(current_path, question_path(current_question))
    should have_content 'This is my answer to the question'
  end

  step 'I should see an error message' do
    should have_content 'Your answer - is too short'
  end

  def fill_in_form(text)
    fill_in 'answer_body', with: text
    find(:xpath, '//input[@name="commit"]').click
  end
end
