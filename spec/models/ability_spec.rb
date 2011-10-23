require 'cancan/matchers'
require 'spec_helper'

describe Ability do
  before(:each) do
    @user = Factory(:user)
    @ability = Ability.new(@user)
  end

  describe "question authorisation" do
    describe "read" do
      it "anyone should be able to view non-deleted questions" do
        Ability.new(nil).should be_able_to(:read, Question.new) 
        @ability.should be_able_to(:read, Question.new)
      end

      it "only moderators should be able to view deleted questions" do
        question = Question.new
        question.deleted_at = Time.now
        Ability.new(nil).should_not be_able_to(:read, question)
        @ability.should_not be_able_to(:read, question)

        @user.role = 'moderator'
        Ability.new(@user).should be_able_to(:read, question)
      end
    end

    describe "create" do
      it "anyone should be able to create questions" do
        ability_with_reputation(0).should be_able_to(:create, Question.new)
      end
    end

    describe "update" do
      it "should not let john smith edit" do
        Ability.new(nil).should_not be_able_to(:update, Question.new)
      end

      it "should not let users with less than 500 reputation edit" do
        ability_with_reputation(0).should_not be_able_to(:update, Question.new)
      end

      it "should let the original creator edit" do
        question = Factory.build(:question)
        Ability.new(question.user).should be_able_to(:update, question)
      end

      it "should let users with more than 500 reputation edit" do
        ability_with_reputation(1000).should be_able_to(:update, Question.new)
      end

      it "should let moderators edit" do
        user = Factory(:user, :role => 'moderator')
        Ability.new(user).should be_able_to(:update, Question.new)
      end
    end
  end
end
