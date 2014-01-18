class Spinach::Features::EditQuestion < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedQuestion

  step 'I am logged in and cannot edit questions' do
    QuestionPolicy.any_instance.stubs(:edit?).returns(false)
    login
  end

  step 'I am logged in and can edit questions' do
    QuestionPolicy.any_instance.stubs(:edit?).returns(true)
    login
  end

  step 'I cannot see a link to edit the question' do
    should_not have_link('edit', href: edit_question_path(current_question.id))
  end

  step 'I can see a link to edit the question' do
    should have_link('edit', href: edit_question_path(current_question.id))
  end

  step 'I visit the question edit page' do
    visit edit_question_path(current_question.id)
  end

  step 'I edit and submit the question data' do
    fill_in 'question_body', with: 'this is an edited question body'
    fill_in 'question_title', with: 'new question title'
    fill_in 'question_tag_list', with: 'new-list, tags'
    find(:xpath, '//input[@name="commit"]').click
  end

  step 'I am on the question page' do
    current_path.should == question_path(Question.first)
  end

  step 'I should see the updated question' do
    should have_content 'this is an edited question body'
    should have_content 'new question title'
  end
end