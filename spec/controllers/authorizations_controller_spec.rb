require 'spec_helper'

describe AuthorizationsController, type: :controller do
  describe 'callback' do
    let(:auth_hash) { OmniAuth.config.mock_auth[:google] }

    before do
      request.env['omniauth.auth'] = auth_hash
    end

    context 'with existing authorization' do
      before do
        user = User.new_from_hash(auth_hash)
        user.authorizations << Authorization.create_from_hash(auth_hash)
        user.save!
      end

      it 'logs the user in if they exist' do
        post :callback, params: { provider: :google }
        expect(response).to be_redirect
      end
    end

    context 'with new authorization' do
      it 'creates an authorization object' do
        expect { post :callback, params: { provider: :google }}
          .to change { Authorization.count }
          .by(1)
      end

      it 'sets the auth id in the session' do
        post :callback, params: { provider: :google }
        expect(session[:auth_id]).to_not be_nil
      end

      it 'renders the new user page' do
        post :callback, params: { provider: :google }
        expect(response).to render_template(:callback)
      end
    end
  end
end
