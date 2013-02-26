Given(/^I am on the homepage$/) do
  visit("/")
end

Given(/^I am on the signup page$/) do
  visit("/signup")
end

Given(/^I am on the login page$/) do
  visit("/login")
end

Then(/^I should be returned to the confirmation page$/) do
  current_path.should == "/auth/google/callback"
end

Then(/^I should be (?:returned|redirected) to the homepage$/) do
  current_path.should == "/"
end

Then(/^I should be on the new question page$/) do
  current_path.should == '/ask'
end