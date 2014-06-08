require 'spec_helper'
require 'controllers/shared/timeline_action'

describe QuestionsController, :type => :controller do
  it_behaves_like 'TimelineAction'

  describe 'index' do
    before { get :index }
    it { is_expected.to respond_with(:success) }
  end

  describe 'show' do
    let(:question) { FactoryGirl.create(:question) }
    before { get :show, id: question.id, slug: question.slug }
    it { is_expected.to respond_with(:success) }
  end

  describe 'tagged' do
    before do
      FactoryGirl.create(:question, tag_list: 'tag')
      get :tagged, tag: 'tag'
    end
    it { is_expected.to respond_with(:success) }
  end

  describe 'ask' do
    it { expect { get :new }.to require_login }

    context 'when logged in' do
      before { sign_in(alice) }

      it 'returns success' do
        get :new
        expect(response).to be_success
      end
    end
  end

  describe 'create' do
    it { expect { post :create }.to require_login }

    context 'when logged in' do
      before { sign_in(alice) }

      it 'creates a question if passed a valid question' do
        question = FactoryGirl.attributes_for(:question)
        post :create, question: question
        expect(Question.last.body).to eq(question[:body])
      end
    end
  end

  describe 'edit' do
    let(:question) { FactoryGirl.create(:question) }

    it { expect { get :edit, id: question.id }.to require_login }

    it 'raises without permissions' do
      sign_in(FactoryGirl.create(:user, reputation: 0))
      expect { get :edit, id: question.id }.to raise_error(Pundit::NotAuthorizedError)
    end

    context 'when logged in with permission' do
      before { sign_in(a_k) }

      it 'returns success' do
        get :edit, id: question.id
        expect(response).to be_success
      end
    end
  end

  describe 'update' do
    let(:question) { FactoryGirl.create(:question) }

    it { expect { put :update, id: question.id }.to require_login }

    it 'raises without permissions' do
      sign_in(FactoryGirl.create(:user, reputation: 0))
      expect { put :update, id: question.id }.to raise_error(Pundit::NotAuthorizedError)
    end

    context 'when logged in with permissions' do
      def req
        sign_in(a_k)
        put :update, id: question.id, question: { title: 'validlengthtitle' }
      end

      it 'makes a call to create a timeline event' do
        Question.any_instance.expects(:edit_timeline_event!)
        req
      end

      it 'updated the information' do
        req
        expect(Question.find(question.id).title).to eq('validlengthtitle')
      end

      it 'redirects back to the question' do
        req
        expect(response).to be_redirect
      end
    end
  end

  describe 'accept_answer' do
    let(:question) { FactoryGirl.create(:question, accepted_answer_id: nil, user: alice) }
    it { expect { post :accept_answer, id: question.id }.to require_login }

    context 'when logged in as the question asker' do
      before { sign_in(alice) }
      let(:answer) { FactoryGirl.create(:answer, question: question) }

      it 'returns bad request if neither accepted answer in question or param' do
        post :accept_answer, id: question.id
        expect(response.status).to eq(400)
      end

      it 'updates the accepted answer id if it is valid' do
        post :accept_answer, id: question.id, answer_id: answer.id
        expect(Question.find(question.id).accepted_answer_id).to eq(answer.id)
      end

      it 'does not update the accepted answer id if it is not an answer on the question' do
        FactoryGirl.create(:answer, id: 999)
        post :accept_answer, id: question.id, answer_id: 999
        expect(Question.find(question.id).accepted_answer_id).to eq(nil)
      end

      it 'removes the accepted answer if there is no answer_id' do
        question.accepted_answer_id = answer.id
        question.save
        post :accept_answer, id: question.id
        expect(Question.find(question.id).accepted_answer_id).to eq(nil)
      end
    end

    context 'when logged in as a different user' do
      it 'raises unauthorised' do
        sign_in(bob)
        post :accept_answer, id: question.id
        expect(response).to be_forbidden
      end
    end
  end
end
