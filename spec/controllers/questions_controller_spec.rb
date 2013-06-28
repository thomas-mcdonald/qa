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

  context 'accept_answer' do
    let(:question) { FactoryGirl.create(:question, accepted_answer_id: nil) }

    it 'requires login' do
      -> { post :accept_answer, id: question.id }.should raise_error(QA::NotLoggedIn)
    end

    context 'when logged in' do
      before { sign_in(alice) }

      it 'updates the accepted answer id if it is valid' do
        answer = FactoryGirl.create(:answer, question_id: question.id)
        post :accept_answer, id: question.id, answer_id: answer.id
        Question.find(question.id).accepted_answer_id.should == answer.id
      end

      it 'does not update the accepted answer id if it is not an answer on the question' do
        FactoryGirl.create(:answer, id: 999)
        post :accept_answer, id: question.id, answer_id: 999
        Question.find(question.id).accepted_answer_id.should == nil
      end
    end
  end
end