Given /^I am logged in$/ do
  Given %q[I have a user with the username "tom", email "tom@example.com", and password "secret"]
  visit login_path
  fill_in "login", :with => "tom"
  fill_in "password", :with => "secret"
  click_button "Log in"
end

Given /^I have a user with the username "([^"]*)", email "([^"]*)", and password "([^"]*)"$/ do |username, email, password|
  User.create(
    :username => username,
    :email => email,
    :password => password,
    :password_confirmation => password
  )
end

Then /^I should see a modal window$/ do
  Then %q[I should see a ".modal"]
end

Then /^I should not see a modal window$/ do
  Then %q[I should not see a ".modal"]
end

Then /^(?:|I )should see a "([^\"]*)"$/ do |selector|
  page.has_css?(selector).should be_true
end

Then /^(?:|I )should not see a "([^\"]*)"?$/ do |selector|
  page.has_css?(selector).should be_false
end

