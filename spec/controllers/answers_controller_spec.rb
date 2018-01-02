require 'spec_helper'
require 'controllers/shared/timeline_action'

describe AnswersController, :type => :controller do
  it_behaves_like 'TimelineAction'

  describe 'create' do
    it { expect { post :create }.to require_login }

    context 'when logged in' do
      let(:question) { FactoryGirl.create(:question) }
      let(:answer) { FactoryGirl.attributes_for(:answer, question_id: question.id) }

      before { sign_in(alice) }

      context 'JSON' do
        it 'creates answer with valid parameters' do
          post :create, params: { answer: answer }, format: :json
          expect(Answer.last.body).to eq(answer[:body])
          expect(Answer.all.length).to eq(1)
        end

        it 'returns errors if the answer is not valid' do
          post :create, params: { answer: answer.merge(body: 'a') }, format: :json
          expect(Answer.all.length).to eq(0)
          expect(response.status).to eq(422)
          res = JSON.parse(response.body)
          expect(res['errors']).to_not be_empty
        end
      end

      context 'HTML' do
        it 'creates answer with valid parameters' do
          post :create, params: { answer: answer }
          expect(Answer.last.body).to eq(answer[:body])
          expect(Answer.all.length).to eq(1)
        end
      end
    end
  end

  describe 'edit' do
    let(:answer) { FactoryGirl.create(:answer) }

    it { expect { get :edit, params: { id: answer.id }}.to require_login }

    it 'requires permissions' do
      sign_in(FactoryGirl.create(:user, reputation: 0))
      expect { get :edit, params: { id: answer.id }}.to raise_error(Pundit::NotAuthorizedError)
    end

    context 'when logged in' do
      before { sign_in(a_k) }

      it 'is success' do
        get :edit, params: { id: answer.id }
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'update' do
    let(:answer) { FactoryGirl.create(:answer) }

    it { expect { post :update, params: { id: answer.id }}.to require_login }

    context 'when logged in' do
      before { sign_in(a_k) }

      it 'creates a timeline event' do
        Answer.any_instance.expects(:edit_timeline_event!)
        post :update, params: { id: answer.id, answer: { body: 'this is a new body' }}
      end

      it 'updates the last activity on the post' do
        last_active = answer.last_active_at
        post :update, params: { id: answer.id, answer: { body: 'this is a new body' }}
        answer.reload
        expect(answer.last_active_at).to_not eq(last_active)
        expect(answer.last_active_user_id).to eq(a_k.id)
      end
    end
  end
end
