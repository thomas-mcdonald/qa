require 'spec_helper'

describe CommentsController do
  describe '#new' do
    it { expect { get :new }.to require_login }

    context 'when logged in' do
      it 'returns success if allowed to create comments' do
        controller.stubs(:authorize).returns(true)
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

      it 'requires permissions' do
        expect(-> { post :create, params: { comment: { body: 'test comment' }}}).to raise_error(Pundit::NotAuthorizedError)
      end

      it 'creates a comment on a question given valid parameters' do
        controller.stubs(:authorize).returns(true)
        question = FactoryGirl.create(:question)
        post :create, params: { comment: {
          post_type: 'Question', post_id: question.id, body: 'Hi this is a test comment'
        }}
        expect(question.comments.size).to eq(1)
      end
    end
  end
end
