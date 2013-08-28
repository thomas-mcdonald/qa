module SharedAuthentication
  include Spinach::DSL

  step 'I am logged in' do
    # ensure there is a user in the database
    create_user unless User.first
    visit '/login'
    click_link_or_button 'google-login'
  end

  def current_user
    @user ||= create_user
  end

  private

  def create_user
    @user = User.new_from_hash(omniauth_hash)
    @user.save
    @user
  end
end