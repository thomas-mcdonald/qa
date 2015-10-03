class Spinach::Features::Signup < Spinach::FeatureSteps
  include SharedPaths

  step 'I open the login modal' do
    visit '/'
    click_link 'login-link'
  end

  step 'I click on the Google provider' do
    click_link_or_button 'google-login-button'
  end

  step 'I should be returned to the confirmation page' do
    assert_path '/auth/google/callback'
  end

  step 'I should see a form for user details filled in' do
    within('#new_user') do
      assert have_field('Name', with: omniauth_hash[:info][:name])
      assert have_field('Email', with: omniauth_hash[:info][:email])
    end
  end

  step 'I submit the user details form' do
    find(:xpath, '//input[@name="commit"]').click
  end

  step 'I should have a user created with those details' do
    user = User.where('name = ?', omniauth_hash[:info][:name]).where('email = ?', omniauth_hash[:info][:email]).first
    refute_nil user
    assert_equal user.authorizations.length, 1
  end

  step 'I should be logged in' do
    refute_text 'Login'
  end
end
