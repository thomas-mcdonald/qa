Then /^I should see a series of links to login providers$/ do
  page.should have_link("google-login", href: "/auth/google")
  page.should have_link("twitter-login", href: "/auth/twitter")
end