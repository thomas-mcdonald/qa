require 'spec_helper'

describe Vote do
  it "should have a valid factory" do
    Factory(:vote).should be_valid
  end

  describe "validation" do
    describe "value" do
      it "requires presence" do
        vote = Factory.build(:vote)
        vote.value = nil
        vote.should have(1).errors_on(:value)
      end

      it "requires numericality" do
        vote = Factory.build(:vote)
        vote.value = "abd"
        vote.should have(1).errors_on(:value)
      end
    end

    describe "user" do
      it "requires presence" do
        vote = Factory.build(:vote)
        vote.user = nil
        vote.should have(1).errors_on(:user_id)
      end
    end

    it "only allow one vote on a particular post by the same user" do
      question = Factory(:question)
      vote = Factory.build(:vote)
      vote.voteable = question
      vote.save
      vote.should be_valid
      v2 = Factory.build(:vote)
      v2.voteable = question
      v2.user = vote.user
      v2.should have(1).errors_on(:voteable)
    end

    it "should not allow a user to vote on his own post" do
      question = Factory.build(:question)
      vote = Factory.build(:vote)
      vote.voteable = question
      vote.user = question.user
      vote.should have(1).errors_on(:voteable)
    end
  end
end

