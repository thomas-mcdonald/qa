class Spinach::Features::AdminUsers < Spinach::FeatureSteps
  include SharedAuthentication

  step 'there exists another user' do
    @path_user = FactoryGirl.create(:user)
  end

  step 'I visit a user admin edit page' do
    visit edit_admin_user_path(@path_user)
  end

  step 'I submit the form with the admin flag checked' do
    check 'user_admin'
    find('input[name="commit"]').click
  end

  step 'I should be redirected to the users page' do
    assert_equal(current_path, user_path(@path_user))
  end

  step 'I should see that they are an admin' do
    within '.page-header' do
      assert_text '♦'
    end
  end
end
