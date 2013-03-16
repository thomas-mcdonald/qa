Given(/^I have already signed up$/) do
  @user = User.new_from_hash(google_hash).save
end

Given(/^I am logged in$/) do
  step 'I have already signed up'
  step 'I am on the login page'
  step 'I click on the Google provider'
  step 'I should be logged in'
end

Given(/^I am not logged in$/) do
  visit '/'
  step 'I click on the logout button' unless has_content?("Login")
end

When(/^I click on the logout button$/) do
  click_link_or_button("user-dropdown")
  click_link_or_button("logout")
end

When(/^I click on the Google provider$/) do
  click_link_or_button("google-login")
end

Then(/^I should see a series of links to login providers$/) do
  should have_link("google-login", href: "/auth/google")
  should have_link("twitter-login", href: "/auth/twitter")
end

Then(/^I should see a form for user details filled in$/) do
  within('#new_user') do
    should have_field('Name', with: google_hash[:info][:name])
    should have_field('Email', with: google_hash[:info][:email])
  end
end

Then(/^I should have a user created with those details$/) do
  user =  User.where('name = ?', google_hash[:info][:name]).where('email = ?', google_hash[:info][:email]).first
  assert user
  assert user.authorizations.length == 1
end

Then(/^I should be logged out$/) do
  should have_content("Login")
end

Then(/^I should be logged in$/) do
  should_not have_content("Login")
end