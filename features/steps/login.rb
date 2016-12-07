class Spinach::Features::Login < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths

  step 'I have already signed up' do
    create_user
  end

  step 'I open the login modal' do
    visit '/'
    click_link 'login-link'
  end

  step 'I click on the Google provider' do
    click_link_or_button 'google-login-button'
  end

  step 'I should be returned to the homepage' do
    assert_path '/'
  end

  step 'I should be logged in' do
    refute_text 'Login'
  end

  step 'I click on the logout button' do
    visit '/'
    find('.user-dropdown').click
    click_link_or_button('logout')
  end

  step 'I should be logged out' do
    assert_text 'Login'
  end
end
