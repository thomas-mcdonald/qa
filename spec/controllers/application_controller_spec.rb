require 'spec_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      head :no_content
    end

    def admin
      require_admin
      head :no_content
    end
  end

  describe 'check_for_orphaned_authorization' do
    let(:authorization) { FactoryGirl.create(:authorization) }

    it 'deletes the authorization object if it exists' do
      session[:auth_id] = authorization.id
      get :index
      expect(Authorization.exists?(authorization.id)).to be false
    end

    it 'sets the auth_id to nil after deletion' do
      session[:auth_id] = authorization.id
      get :index
      expect(session[:auth_id]).to be_nil
    end

    it 'does not delete an object if the referenced object does not exist' do
      session[:auth_id] = 123456
      expect { get :index }.to_not change { Authorization.count }
    end

    it 'sets the auth_id to nil even if the object does not exist' do
      session[:auth_id] = 123456
      get :index
      expect(session[:auth_id]).to be_nil
    end
  end

  describe 'require_admin' do
    before { routes.draw { get 'admin' => 'anonymous#admin' } }
    let(:admin) { FactoryGirl.create(:user, admin: true) }
    let(:user) { FactoryGirl.create(:user) }

    it 'raises an error if the user is not an administrator' do
      session[:user_id] = user.id
      expect { get :admin }.to raise_error(QA::NotAuthorised)
    end

    it 'does not raise an error if the user is an admin' do
      session[:user_id] = admin.id
      expect { get :admin }.to_not raise_error
    end
  end
end
