require 'spec_helper'

shared_examples_for 'voteable' do
  let(:item) { FactoryGirl.create(described_class.to_s.downcase.to_sym) }

  context 'vote_count' do
    it 'counts upvotes as 1' do
      FactoryGirl.create(:upvote, post: item)
      item.reload
      item.vote_count.should == 1
    end

    it 'counts downvotes as -1' do
      FactoryGirl.create(:downvote, post: item)
      item.reload
      item.vote_count.should == -1
    end

    it 'handles a series of votes' do
      FactoryGirl.create(:upvote, post: item)
      FactoryGirl.create(:downvote, post: item)
      FactoryGirl.create(:upvote, post: item)
      item.reload
      item.vote_count.should == 1
    end

    it 'updates after vote destroy' do
      vote = FactoryGirl.create(:upvote, post: item)
      item.reload
      item.vote_count.should == 1
      vote.destroy
      item.reload
      item.vote_count.should == 0
    end
  end

  context 'has_vote_by_user' do
    let(:user) { FactoryGirl.create(:user) }

    it 'does not have a vote by default' do
      item.has_vote_by_user(user, 1).should == false
    end

    it 'has a vote if there has been one created' do
      item.votes << FactoryGirl.build(:upvote, user: user)
      item.has_vote_by_user(user, 1).should == true
    end
  end
end