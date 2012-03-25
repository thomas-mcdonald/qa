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