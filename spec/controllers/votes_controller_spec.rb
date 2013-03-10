require 'spec_helper'

describe VotesController do
  let(:question) { FactoryGirl.create(:question) }
  context 'create' do
    it 'requires login' do
      -> { post :create }.should raise_error(QA::NotLoggedIn)
    end

    context 'logged in' do
      before { sign_in(alice) }

      it 'creates a vote with valid parameters' do
        post :create, vote: FactoryGirl.attributes_for(:upvote, post: question)
        Vote.all.length.should == 1
      end
    end
  end
end