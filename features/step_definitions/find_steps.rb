When /^I click on the Google provider$/ do
  click_link_or_button("google-login")
end

Then /^I should see a series of links to login providers$/ do
  page.should have_link("google-login", href: "/auth/google")
  page.should have_link("twitter-login", href: "/auth/twitter")
end

Then /^I should see a title of "([^"]*)"$/ do |title|
  within(".page-header h1") do
    should have_content(title)
  end
end