module SharedAuthentication
  include Spinach::DSL

  step 'I am logged in' do
    login
  end

  def login
    create_user unless User.first
    visit '/' # ensure we are on a page - login may be first action called
    click_link 'login-link'
    click_link_or_button 'google-login-button'
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
