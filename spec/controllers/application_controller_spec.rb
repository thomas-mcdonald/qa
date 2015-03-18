require 'spec_helper'

describe ApplicationController, type: :controller do
  controller do
    def index
      render nothing: true
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
end
