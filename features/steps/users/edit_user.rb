class Spinach::Features::EditUser < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths

  step 'I update my name and submit the form' do
    fill_in 'user_name', with: 'Ed Balls'
    find(:xpath, '//input[@name="commit"]').click
  end

  step 'I should be redirected to my profile page' do
    assert_path user_path(current_user.reload)
  end

  step 'I should see my updated name' do
    assert_text 'Ed Balls'
  end
end
