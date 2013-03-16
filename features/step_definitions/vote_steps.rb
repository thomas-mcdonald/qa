When(/^I click on the upvote question button$/) do
  find('.question button:not([disabled]) .icon-chevron-up').click
end

Then(/^I am told I have to log in$/) do
  within('.popover') do
    should have_content 'You must be logged in to vote'
  end
end

Then(/^I should see an active upvote$/) do
  # todo: check for upvote rather than just active vote
  should have_css('.question .vote-active')
end

Then(/^I should see an updated vote count$/) do
  find('.question .vote-count').should have_content '1'
end