module UserSupport
  def a_k
    # a user with 1000 reputation
    @a_k ||= FactoryGirl.create(:user, name: 'AK', reputation: 1000)
  end

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