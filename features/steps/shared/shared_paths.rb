module SharedPaths
  include Spinach::DSL

  step 'I visit the login page' do
    visit '/login'
  end

  step 'I visit the signup page' do
    visit '/login'
  end

  step 'I visit the new question page' do
    visit new_question_path
  end

  step 'I visit the question page' do
    visit question_path(current_question)
  end

  step 'I visit the answer edit page' do
    visit edit_answer_path(current_answer)
  end

  step 'I visit the user edit page' do
    visit edit_user_path
  end
end