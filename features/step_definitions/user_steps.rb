When(/^I click on the Google provider$/) do
  click_link_or_button("google-login")
end

Then(/^I should see a series of links to login providers$/) do
  should have_link("google-login", href: "/auth/google")
  should have_link("twitter-login", href: "/auth/twitter")
end

Then(/^I should see a form for user details filled in$/) do
  within('#new_user') do
    should have_field('Name', with: 'John Doe')
    should have_field('Email', with: 'example@google.com')
  end
end

Then(/^I should have a user created with those details$/) do
  user =  User.where('name = ?', 'John Doe').where('email = ?', 'example@google.com').first
  assert user
  assert user.authorizations.length == 1
end