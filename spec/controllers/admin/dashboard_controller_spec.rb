require 'spec_helper'

describe Admin::DashboardController do
  context 'while logged in as an administrator' do
    before(:each) { sign_in(admin) }

    context '#index' do
      it 'returns success' do
        get :index
        expect(response).to be_success
      end
    end

    it 'health returns success' do
      get :health
      expect(response).to be_success
    end
  end
end
