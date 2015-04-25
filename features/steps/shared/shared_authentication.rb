module SharedAuthentication
  include Spinach::DSL

  step 'I am logged in' do
    login
  end

  step 'I am logged in as an admin' do
    FactoryGirl.create(:admin)
    OmniAuth.config.mock_auth[:google] = admin_omniauth_hash
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

  def admin_omniauth_hash
    {
      info: {
        email: 'example@google.com',
        name: 'John Doe'
      },
      provider: 'google',
      uid: 'https://www.google.com/accounts/o8/id?id=adminuid'
    }
  end

  private

  def create_user
    @user = User.new_from_hash(omniauth_hash)
    @user.authorizations << Authorization.create_from_hash(omniauth_hash)
    @user.save
    @user
  end
end
