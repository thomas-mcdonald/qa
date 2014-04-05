require 'spec_helper'
require 'controllers/shared/timeline_action'

describe AnswersController do
  it_behaves_like 'TimelineAction'

  describe 'create' do
    it { -> { post :create }.should require_login }

    context 'when logged in' do
      let(:question) { FactoryGirl.create(:question) }
      let(:answer) { FactoryGirl.attributes_for(:answer) }

      before { sign_in(alice) }

      it 'creates answer with valid parameters' do
        post :create, answer: answer.merge(question_id: question.id)
        Answer.last.body.should == answer[:body]
        Answer.all.length.should == 1
      end
    end
  end

  describe 'edit' do
    let(:answer) { FactoryGirl.create(:answer) }

    it { -> { get :edit, id: answer.id }.should require_login }

    it 'requires permissions' do
      sign_in(FactoryGirl.create(:user, reputation: 0))
      -> { get :edit, id: answer.id }.should raise_error(Pundit::NotAuthorizedError)
    end

    context 'when logged in' do
      before { sign_in(a_k) }

      it 'is success' do
        get :edit, id: answer.id
        response.status.should == 200
      end
    end
  end

  describe 'update' do
    let(:answer) { FactoryGirl.create(:answer) }

    it { -> { post :update, id: answer.id }.should require_login }

    context 'when logged in' do
      before { sign_in(a_k) }

      it 'creates a timeline event' do
        Answer.any_instance.expects(:edit_timeline_event!)
        post :update, id: answer.id, answer: { body: 'this is a new body' }
      end
    end
  end
end
