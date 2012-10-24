require 'spec_helper'

describe Vote do
  it "should have a valid factory" do
    FactoryGirl.create(:vote).should be_valid
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:voteable) }
    it { should have_one(:reputation_event) }
  end

  describe "validation" do
    it { should validate_presence_of(:value) }
    it { should validate_numericality_of(:value) }
    it { should validate_presence_of(:user_id) }
    it { should validate_numericality_of(:user_id) }

    it "only allow one vote on a particular post by the same user" do
      question = FactoryGirl.create(:question)
      vote = FactoryGirl.build(:vote)
      vote.voteable = question
      vote.save
      vote.should be_valid
      v2 = FactoryGirl.build(:vote)
      v2.voteable = question
      v2.user = vote.user
      v2.should have(1).errors_on(:voteable)
    end

    it "should not allow a user to vote on his own post" do
      question = FactoryGirl.build(:question)
      vote = FactoryGirl.build(:vote)
      vote.voteable = question
      vote.user = question.user
      vote.should have(1).errors_on(:voteable)
    end
  end
end

