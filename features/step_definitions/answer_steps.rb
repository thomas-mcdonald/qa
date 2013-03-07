When(/^I fill in the answer form$/) do
  fill_in 'answer_body', with: 'This is my answer to the question'
end

Then(/^I should see the answer$/) do
  should have_content 'This is my answer to the question'
end