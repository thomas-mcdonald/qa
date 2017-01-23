class Spinach::Features::IndexPage < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedQuestion

  step 'I visit the index page' do
    visit '/'
  end

  step 'those questions have been voted on' do
    # TODO: brittle, refactor this to use standard VoteCreator path
    create(:upvote, post: current_questions.first)
    current_questions.first.update_vote_count!
  end

  step 'I click on the votes tab' do
    find('.pt-tab', text: 'votes').click
  end

  step 'I should see those questions' do
    current_questions.each do |question|
      assert page.has_css?('.qa-question-list-title', text: question.title)
    end
  end

  step 'they should be in vote sorted order' do
    css_finder = '.qa-question-list-title:first-of-type'
    assert page.has_css?(css_finder, text: current_questions.first.title)
  end
end
