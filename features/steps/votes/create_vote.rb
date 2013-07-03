class Spinach::Features::CreateVote < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedPaths
  include SharedQuestion

  step 'I click on the upvote question button' do
    find('.question button:not([disabled]) .icon-chevron-up').click
  end

  step 'I am told I have to log in' do
    within('.popover') do
      should have_content 'You must be logged in to vote'
    end
  end

  step 'I see an active upvote' do
    # todo: check for upvote rather than just active vote
    should have_css('.question .vote-active')
  end

  step 'I see an updated vote count' do
    find('.question .vote-count').should have_content '1'
  end

  step 'I do not see an active upvote' do
    should_not have_css('.question .vote-active')
  end

  step 'I am told I cannot vote on my own posts' do
    within('.popover') do
      should have_content 'You cannot vote on your own posts'
    end
  end
end