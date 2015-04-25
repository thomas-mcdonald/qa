require 'spec_helper'

describe Admin::UsersController do
  let(:admin) { FactoryGirl.create(:user, admin: true)}
  let(:user) { FactoryGirl.create(:user) }

  def as_admin
    session[:user_id] = admin.id
  end

  describe 'edit' do
    it 'requires login by an administrator' do
      expect { get :edit, id: user.id }.to raise_error(QA::NotAuthorised)
    end

    it 'is successful as admin' do
      as_admin
      get :edit, id: user.id
      expect(response).to be_success
    end

    it 'loads the user data' do
      as_admin
      get :edit, id: user.id
      expect(assigns(:user)).to be_a(User)
    end
  end

  describe 'update' do
    it 'requires login by an administrator' do
      expect { put :update, id: user.id }.to raise_error(QA::NotAuthorised)
    end

    it 'redirects to the user page' do
      as_admin
      put :update, id: user.id, user: { admin: false, moderator: false }
      expect(response).to redirect_to(user)
    end
  end
end
