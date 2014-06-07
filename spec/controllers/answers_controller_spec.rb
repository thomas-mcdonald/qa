require 'spec_helper'
require 'controllers/shared/timeline_action'

describe AnswersController, :type => :controller do
  it_behaves_like 'TimelineAction'

  describe 'create' do
    it { expect { post :create }.to require_login }

    context 'when logged in' do
      let(:question) { FactoryGirl.create(:question) }
      let(:answer) { FactoryGirl.attributes_for(:answer) }

      before { sign_in(alice) }

      it 'creates answer with valid parameters' do
        post :create, answer: answer.merge(question_id: question.id)
        expect(Answer.last.body).to eq(answer[:body])
        expect(Answer.all.length).to eq(1)
      end
    end
  end

  describe 'edit' do
    let(:answer) { FactoryGirl.create(:answer) }

    it { expect { get :edit, id: answer.id }.to require_login }

    it 'requires permissions' do
      sign_in(FactoryGirl.create(:user, reputation: 0))
      expect { get :edit, id: answer.id }.to raise_error(Pundit::NotAuthorizedError)
    end

    context 'when logged in' do
      before { sign_in(a_k) }

      it 'is success' do
        get :edit, id: answer.id
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'update' do
    let(:answer) { FactoryGirl.create(:answer) }

    it { expect { post :update, id: answer.id }.to require_login }

    context 'when logged in' do
      before { sign_in(a_k) }

      it 'creates a timeline event' do
        Answer.any_instance.expects(:edit_timeline_event!)
        post :update, id: answer.id, answer: { body: 'this is a new body' }
      end
    end
  end
end
