Given /^I am on the homepage$/ do
  visit("/")
end

Given /^I am on the signup page$/ do
  visit("/signup")
end

Then /^I should be on the Google authentication page$/ do
  current_path = URI.parse(current_url).path
  current_path.should == "/auth/google"
end