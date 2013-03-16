# steps relating to questions
Given(/^I have a question$/) do
  @question = FactoryGirl.create(:question)
end

Given(/^I am on the question page$/) do
  visit question_path(@question)
end

When(/^I click on the Ask Question button$/) do
  find(:xpath, '//a[@href="/ask"]').click
end

When(/^I fill in the form with question data$/) do
  fill_in 'question_title', with: "Example title of question?"
  fill_in 'question_body', with: "A really long and confusion body to a non existant question. Plese advise?"
end

Then(/^I should be on the question page$/) do
  # should the regex incude the slug here? maybe
  current_path.should match(/questions\/\d/)
end

Then(/^I should see the question$/) do
  should have_content("Example title of question?")
  should have_content("A really long and confusion") # etc
end