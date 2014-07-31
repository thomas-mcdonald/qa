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

  describe '#create' do
    it { expect { post :create }.to require_login }

    context 'when logged in' do
      before { sign_in(alice) }

      it 'creates a comment on a question given valid parameters' do
        question = FactoryGirl.create(:question)
        post :create, comment: {
          post_type: 'Question', post_id: question.id, body: 'Hi this is a test comment'
        }
        expect(question.comments.size).to eq(1)
      end
    end
  end
end
