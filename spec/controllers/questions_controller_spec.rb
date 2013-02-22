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
end