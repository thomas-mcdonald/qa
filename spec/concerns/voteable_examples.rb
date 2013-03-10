require 'spec_helper'

shared_examples_for 'voteable' do
  let(:item) { FactoryGirl.create(described_class.to_s.downcase.to_sym) }

  context 'vote_count' do
    it 'counts upvotes as 1' do
      item.votes << Vote.new(vote_type_id: 1)
      item.vote_count.should == 1
    end

    it 'counts downvotes as -1' do
      item.votes << Vote.new(vote_type_id: 2)
      item.vote_count.should == -1
    end

    it 'handles a series of votes' do
      item.votes << Vote.new(vote_type_id: 1)
      item.votes << Vote.new(vote_type_id: 2)
      item.votes << Vote.new(vote_type_id: 1)

      item.vote_count.should == 1
    end
  end
end