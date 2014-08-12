require 'spec_helper'

describe VotesController, :type => :controller do
  let(:question) { FactoryGirl.create(:question) }
  let(:vote) { FactoryGirl.attributes_for(:upvote) }

  describe 'create' do
    it 'requires login' do
      post :create
      expect(response.status).to eq(401)
    end

    context 'logged in' do
      before { sign_in(alice) }

      let(:vote_params) { vote.merge(post_type: 'Question', post_id: question.id) }

      it 'creates a vote with valid parameters' do
        post :create, vote: vote_params
        expect(Vote.all.length).to eq(1)
      end

      it 'does not create two upvotes' do
        post :create, vote: vote_params
        post :create, vote: vote_params
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'destroy' do
    it 'requires login' do
      delete :destroy, id: 1
      expect(response.status).to eq(401)
    end

    context 'logged_in' do
      before { sign_in(alice) }
      let(:self_vote) { FactoryGirl.create(:upvote, user: alice) }

      it 'destroys the vote if it is the same user' do
        Vote.any_instance.expects(:destroy).returns(true)
        delete :destroy, id: self_vote.id
      end

      it 'returns unauthorized if it is a different user' do
        vote = FactoryGirl.create(:upvote)
        delete :destroy, id: vote.id
        expect(response.status).to eq(403)
      end

      it 'does not delete the vote if it is locked' do
        Vote.any_instance.stubs(:locked?).returns(true)
        delete :destroy, id: self_vote.id
        expect(response.status).to eq(403)
      end
    end
  end
end
