class Spinach::Features::CreateComment < Spinach::FeatureSteps
  include SharedAuthentication
  include SharedQuestion
  include SharedPaths

  COMMENT_BODY = 'This is a test comment innit'

  step 'I can create comments' do
    CommentPolicy.any_instance.stubs(:create?).returns(true)
  end

  step 'I click on add comment' do
    find('.question .add-comment').click
  end

  step 'I fill out the comment form and submit it' do
    fill_in 'comment_body', with: COMMENT_BODY
    find(:xpath, '//form[@id="new_comment"]//input[@name="commit"]').click
  end

  step 'I should see the comment' do
    assert_path question_path(current_question)
    assert_text COMMENT_BODY
  end
end
