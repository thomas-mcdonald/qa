require 'spec_helper'

describe Answer do
  it "has a valid factory" do
    FactoryGirl.create(:answer).should be_valid
  end

  describe "associations" do
    it { should have_many(:badges) }
    it { should have_many(:flags) }
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:votes) }
  end

  describe "validation" do
    it { should validate_numericality_of(:question_id) }
    it { should validate_numericality_of(:user_id) }
    it { should validate_presence_of(:body) }
    it { should ensure_length_of(:body).is_at_least(30) }
  end

  describe "#deleted" do
    it "should include deleted answers" do
      answer = FactoryGirl.create(:answer).destroy
      Answer.deleted.should include(answer)
    end

    it "should not include non-deleted answers" do
      answer = FactoryGirl.create(:answer)
      Answer.deleted.should_not include(answer)
    end
  end

  describe ".vote_count" do
    it "should be 0 for new posts" do
      FactoryGirl.create(:answer).vote_count.should == 0
    end

    it "should be 1 for a post with 2 upvotes and 1 downvote" do
      answer = FactoryGirl.create(:answer)
      FactoryGirl.create(:vote, :voteable => answer, :value => 1)
      FactoryGirl.create(:vote, :voteable => answer, :value => 1)
      FactoryGirl.create(:vote, :voteable => answer, :value => -1)
      answer.vote_count.should == 1
    end

    it "should be -1 for a post with 1 downvote" do
      answer = FactoryGirl.create(:answer)
      FactoryGirl.create(:vote, :voteable => answer, :value => -1)
      answer.vote_count.should == -1
    end
  end

  describe ".appear_deleted?" do
    pending
  end
end

