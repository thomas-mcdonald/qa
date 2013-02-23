require 'spec_helper'

describe QuestionsController do
  context 'index' do
    before do
      get :index
    end

    it { should respond_with(:success) }
  end

  context 'ask' do
    it 'requires login' do
      -> { get :new }.should raise_error(QA::NotLoggedIn)
    end
  end

  context 'create' do
    it 'requires login' do
      -> { post :create }.should raise_error(QA::NotLoggedIn)
    end
  end

  context 'edit' do
    it 'requires login' do
      -> { get :edit }.should raise_error(QA::NotLoggedIn)
    end

    context 'when logged in' do
      before do
        sign_in(alice)
      end

      it 'returns success' do
        response.should be_success
      end
    end
  end
end