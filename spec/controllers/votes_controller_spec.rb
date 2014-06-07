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
end
