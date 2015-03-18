class Spinach::Features::CreateQuestion < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedTagInterface

  step 'I submit the form with a valid question' do
    fill_in_form
    find(:xpath, '//input[@name="commit"]').click
  end

  step 'I should see the question' do
    current_path.should == question_path(Question.last)
    should have_content(@data[:title])
    should have_content(@data[:body]) # etc
  end

  step 'I submit the form with question data but without any tags' do
    fill_in_form
    remove_tag
    find(:xpath, '//input[@name="commit"]').click
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
    input_and_add_tags(@data[:tag_list])
  end
end
