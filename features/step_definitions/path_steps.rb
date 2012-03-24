Given(/^I am on the homepage$/) do
  visit("/")
end

Given(/^I am on the signup page$/) do
  visit("/signup")
end

Then(/^I should be returned to the confirmation page$/) do
  current_path.should == "/auth/google/callback"
end