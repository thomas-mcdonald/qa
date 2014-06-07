require 'spec_helper'

describe CommentsController do
  describe '#new' do
    it { expect { get :new }.to require_login }

    context 'when logged in' do
      it 'returns success' do
        sign_in(alice)
        get :new
        expect(response).to be_success
      end
    end
  end
end
