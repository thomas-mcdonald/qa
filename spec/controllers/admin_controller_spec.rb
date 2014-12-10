require 'spec_helper'

describe AdminController do
  context 'while logged in as an administrator' do
    before(:each) { sign_in(admin) }

    context '#index' do
      it 'returns success' do
        get :index
        expect(response.status).to eq(200)
      end
    end
  end
end
