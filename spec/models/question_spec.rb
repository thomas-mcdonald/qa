require 'spec_helper'

describe Question do
  it "has a valid factory" do
    Factory(:question).should be_valid
  end

  describe "associations" do
    it { should have_many(:answers) }
    it { should have_many(:badges) }
    it { should have_many(:flags) }
    it { should have_many(:taggings) }
    it { should have_many(:tags).through(:taggings) }
    it { should have_many(:votes) }
    it { should belong_to(:user) }
    it { should belong_to(:last_active_user) }
  end

  describe "validation" do
    it { should validate_presence_of(:title) }
    it { should ensure_length_of(:title).is_at_least(10).is_at_most(150) }
    it { should validate_presence_of(:body) }
    it { should ensure_length_of(:body).is_at_least(30) }
    it { should validate_presence_of(:user_id) }
    it { should validate_numericality_of(:user_id) }
  end

  describe "scopes" do
    # TODO: sort these tests out
    before(:each) do
      @questions = []
      3.times do |i|
        @questions << Factory(:question)
      end
      @questions[1].destroy # Delete the middle item
    end

    it "default scope should return deleted items" do
      questions = Question.all
      questions.size.should == 3
      questions.should include(@questions[1])
    end

    it "deleted 'scope' should return only deleted items" do
      questions = Question.deleted.all
      questions.size.should == 1
      questions.should include(@questions[1])
    end
  end

  describe ".vote_count" do
    it "should be 0 for new posts" do
      Factory(:question).vote_count.should == 0
    end

    it "should be 1 for a post with 2 upvotes and 1 downvote" do
      question = Factory(:question)
      Factory(:vote, :voteable => question, :value => 1)
      Factory(:vote, :voteable => question, :value => 1)
      Factory(:vote, :voteable => question, :value => -1)
      question.vote_count.should == 1 
    end

    it "should be -1 for a post with 1 downvote" do
      question = Factory(:question)
      Factory(:vote, :voteable => question, :value => -1)
      question.vote_count.should == -1
    end
  end
end
