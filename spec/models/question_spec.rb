require 'spec_helper'

describe Question do
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:title).is_at_least(10).is_at_most(150) }

  context 'vote_count' do
    let(:question) { FactoryGirl.create(:question) }

    it 'counts upvotes as 1' do
      question.votes << Vote.new(vote_type_id: 1)
      question.vote_count.should == 1
    end

    it 'counts downvotes as -1' do
      question.votes << Vote.new(vote_type_id: 2)
      question.vote_count.should == -1
    end

    it 'handles a series of votes' do
      question.votes << Vote.new(vote_type_id: 1)
      question.votes << Vote.new(vote_type_id: 2)
      question.votes << Vote.new(vote_type_id: 1)

      question.vote_count.should == 1
    end
  end
end