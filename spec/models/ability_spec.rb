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
  end
end
