require 'spec_helper'

shared_examples_for 'voteable' do
  let(:item) { FactoryGirl.create(described_class.to_s.downcase.to_sym) }

  context 'vote_count' do
    it 'counts upvotes as 1' do
      item.votes << FactoryGirl.build(:upvote)
      item.vote_count.should == 1
    end

    it 'counts downvotes as -1' do
      item.votes << FactoryGirl.build(:downvote)
      item.vote_count.should == -1
    end

    it 'handles a series of votes' do
      item.votes << FactoryGirl.build(:upvote)
      item.votes << FactoryGirl.build(:downvote)
      item.votes << FactoryGirl.build(:upvote)

      item.vote_count.should == 1
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