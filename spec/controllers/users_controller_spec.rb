require 'spec_helper'

describe UsersController, type: :controller do
  describe 'index' do
    it 'loads successfully' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'show' do
    let(:user) { FactoryGirl.create(:user) }

    context 'with slug' do
      before do
        get :show, id: user.to_param
      end

      it { is_expected.to respond_with(:success) }
    end

    it 'redirect if slug is incorrect or missing' do
      get :show, id: user.id
      expect(response.status).to eq(302)
    end
  end

  describe 'answers' do
    let(:user) { FactoryGirl.create(:user) }

    it 'is successful' do
      get :answers, id: user.to_param
      expect(response.status).to eq(200)
    end
  end

  describe 'questions' do
    let(:user) { FactoryGirl.create(:user) }

    it 'is successful' do
      get :questions, id: user.to_param
      expect(response.status).to eq(200)
    end
  end

  describe 'edit' do
    before { sign_in(alice) }
    it 'loads successfully' do
      get :edit
      expect(response.status).to eq(200)
    end
  end

  describe 'update' do
    before { sign_in(alice)}

    it 'rejects updates done by a different user' do
      expect { patch :update, id: bob.id, user: {name: 'Ed Balls'} }.to raise_error(QA::NotAuthorised)
    end

    it 'allows and updates if valid user' do
      patch :update, id: alice.id, user: { name: 'Ed Balls' }
      expect(alice.reload.name).to eq('Ed Balls')
    end
  end
end
