# Only include steps that can be used across multiple features
When(/^I click on the submit button$/) do
  find(:xpath, '//input[@name="commit"]').click
end

Then(/^I should see a title of "([^"]*)"$/) do |title|
  within(".page-header h1") do
    should have_content(title)
  end
end