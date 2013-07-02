class Spinach::Features::CreateQuestion < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths

  step 'I fill in the form with question data' do
    fill_in_form
  end

  step 'I click on the submit button' do
    find(:xpath, '//input[@name="commit"]').click
  end

  step 'I am on the question page' do
    current_path.should == question_path(Question.last)
  end

  step 'I should see the question' do
    should have_content(@data[:title])
    should have_content(@data[:body]) # etc
  end

  step 'I fill in the form with question data but without any tags' do
    fill_in_form
    fill_in 'question_tag_list', with: ''
  end

  step 'I am on the new question page' do
    should have_content 'Ask Question'
  end

  step 'I should see that there is an error with the tags' do
    should have_content('Question must be tagged')
  end

  private

  def fill_in_form
    @data = FactoryGirl.attributes_for(:question)
    fill_in 'question_title', with: @data[:title]
    fill_in 'question_body', with: @data[:body]
    fill_in 'question_tag_list', with: @data[:tag_list]
  end
end