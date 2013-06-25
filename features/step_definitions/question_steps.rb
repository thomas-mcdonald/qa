# steps relating to questions
Given(/^I have a question$/) do
  @question = FactoryGirl.create(:question)
end

Given(/^I have a question by me$/) do
  @question = FactoryGirl.create(:question, user: User.last)
end

Given(/^I asked a question with an answer$/) do
  @question = FactoryGirl.create(:question, user: User.last)
  FactoryGirl.create(:answer, question: @question)
end

Given(/^I (?:am on|visit) the question page$/) do
  visit question_path(@question)
end

When(/^I click on the Ask Question button$/) do
  find(:xpath, '//a[@href="/ask"]').click
end

When(/^I fill in the form with question data but without any tags$/) do
  step 'I fill in the form with question data'
  fill_in 'question_tag_list', with: ''
end

When(/^I fill in the form with question data$/) do
  @data = FactoryGirl.attributes_for(:question)
  fill_in 'question_title', with: @data[:title]
  fill_in 'question_body', with: @data[:body]
  fill_in 'question_tag_list', with: @data[:tag_list]
end

Then(/^I should be on the question page$/) do
  # should the regex incude the slug here? maybe
  current_path.should match(/questions\/\d/)
end

Then(/^I should still be on the new question page$/) do
  current_path.should == '/questions'
  should have_content 'Ask Question'
end

Then(/^I should see buttons to accept the answer$/) do
  within('.answer') do
    should have_css '.accept-answer'
  end
end

When(/^I click on the accept answer button$/) do
  find('.answer .accept-answer').click
end

Then(/^I should see it become active$/) do
  within('.accept-answer button') do
    should have_css '.icon-ok.active'
  end
end

Then(/^I should see the question$/) do
  should have_content(@data[:title])
  should have_content(@data[:body]) # etc
end

Then(/^I should see that there is an error with the tags$/) do
  should have_content('Question must be tagged')
end