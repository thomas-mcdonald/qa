module UserSupport
  def alice
    @alice ||= FactoryGirl.create(:user, name: 'Alice')
  end

  def bob
    @bob || FactoryGirl.create(:user, name: 'Bob')
  end

  def sign_in(user)
    request.session[:user_id] = user.id
  end
end