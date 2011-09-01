require 'spec_helper'

describe Answer do
  it "has a valid factory" do
    Factory(:answer).should be_valid
  end

  describe "validation" do
    describe "of question_id" do
      it "requires presence" do
        answer = Factory.build(:answer)
        answer.question_id = nil
        answer.should have(1).errors_on(:question_id)
      end
    end

    describe "of user_id" do
      it "requires presence" do
        answer = Factory.build(:answer)
        answer.user_id = nil
        answer.should have(1).errors_on(:user_id)
      end
    end

    describe "of body" do
      it "requires presence" do
        answer = Factory.build(:answer)
        answer.body = nil
        answer.should have(1).errors_on(:body)
      end

      it "should have a minimum length of 30 characters" do
        answer = Factory.build(:answer)
        answer.body = "Lorem ipsum dolor sit nullam." # 29char
        answer.should have(1).errors_on(:body)

        answer.body = "Lorem ipsum dolor sit posuere." # 30char
        answer.should have(0).errors_on(:body)
      end
    end
  end
end
