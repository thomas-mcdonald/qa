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

    context 'when logged in' do
      before { sign_in(alice) }

      it 'returns success' do
        get :new
        response.should be_success
      end
    end
  end

  context 'create' do
    it 'requires login' do
      -> { post :create }.should raise_error(QA::NotLoggedIn)
    end

    context 'when logged in' do
      before { sign_in(alice) }

      it 'creates a question if passed a valid question' do
        question = FactoryGirl.attributes_for(:question)
        post :create, question: question
        Question.last.body.should == question[:body]
      end
    end
  end

  context 'edit' do
    let(:question) { FactoryGirl.create(:question) }

    it 'requires login' do
      -> { get :edit, id: question.id }.should raise_error(QA::NotLoggedIn)
    end

    context 'when logged in' do
      before { sign_in(alice) }

      it 'returns success' do
        get :edit, id: question.id
        response.should be_success
      end
    end
  end

  context 'update' do
    let(:question) { FactoryGirl.create(:question) }

    it 'requires login' do
      -> { put :update, id: question.id }.should raise_error(QA::NotLoggedIn)
    end

    context 'when logged in' do
      before do
        sign_in(alice)
        put :update, id: question.id, question: { title: 'validlengthtitle' }
      end

      it 'updated the information' do
        Question.find(question.id).title.should == 'validlengthtitle'
      end

      it 'redirects back to the question' do
        response.should be_redirect
      end
    end
  end
end