class Spinach::Features::Login < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths

  step 'I have already signed up' do
    create_user
  end

  step 'I click on the Google provider' do
    click_link_or_button('google-login')
  end

  step 'I should be returned to the homepage' do
    current_path.should == '/'
  end

  step 'I should be logged in' do
    should_not have_content('Login')
  end

  step 'I click on the logout button' do
    click_link_or_button('user-dropdown')
    click_link_or_button('logout')
  end

  step 'I should be logged out' do
    should have_content('Login')
  end
end