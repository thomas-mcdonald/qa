When(/^I fill in the answer form$/) do
  fill_in 'answer_body', with: 'This is my answer to the question'
end

Then(/^I should see the answer$/) do
  should have_content 'This is my answer to the question'
end

Given(/^I have a question with an answer$/) do
  @answer = FactoryGirl.create(:answer)
  @question = @answer.question
end

Then(/^I cannot see a link to edit the answer$/) do
  within('.answer .links') do
    should_not have_content('edit')
  end
end

Then(/^I can see a link to edit the answer$/) do
  within('.answer .links') do
    should have_content('edit')
  end
end

Given(/^I am on the answer edit page$/) do
  visit edit_answer_path(@answer)
end

When(/^I fill out the form with updated answer information$/) do
  fill_in 'answer_body', with: 'Actually, I believe the answer should be more like this'
end


Then(/^I can see the updated answer$/) do
  within('.answer') do
    should have_content 'Actually, I believe the answer should be more like this'
  end
end