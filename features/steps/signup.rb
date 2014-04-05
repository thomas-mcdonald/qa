class Spinach::Features::Signup < Spinach::FeatureSteps
  include SharedPaths

  step 'I click on the Google provider' do
    click_link_or_button('google-login')
  end

  step 'I should be returned to the confirmation page' do
    current_path.should == '/auth/google/callback'
  end

  step 'I should see a form for user details filled in' do
    within('#new_user') do
      should have_field('Name', with: omniauth_hash[:info][:name])
      should have_field('Email', with: omniauth_hash[:info][:email])
    end
  end

  step 'I submit the user details form' do
    find(:xpath, '//input[@name="commit"]').click
  end

  step 'I should have a user created with those details' do
    user =  User.where('name = ?', omniauth_hash[:info][:name]).where('email = ?', omniauth_hash[:info][:email]).first
    user.should_not be_nil
    user.authorizations.length.should == 1
  end

  step 'I should be logged in' do
    should_not have_content('Login')
  end
end
