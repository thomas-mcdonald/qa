require 'spec_helper'

describe Question do
  it "has a valid factory" do
    Factory(:question).should be_valid
  end

  describe "validation" do
    describe "of title" do
      it "requires presence" do
        question = Factory.build(:question)
        question.title = nil
        question.should have(1).errors_on(:title)
      end

      it "should at least 10 characters" do
        question = Factory.build(:question)
        question.title = "Shorty"
        question.should have(1).errors_on(:title)
      end

      it "should be shorter than 150 characters" do
        question = Factory.build(:question)
        question.title = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut consequat aliquam nisi eget luctus. In nec massa in libero rhoncus pulvinar viverra fusce."
        question.should have(0).errors_on(:title)
        question.title = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut consequat aliquam nisi eget luctus. In nec massa in libero rhoncus pulvinar viverra fusce.."
        question.should have(1).errors_on(:title)
      end
    end

    describe "of body" do
      it "requires presence" do
        question = Factory.build(:question)
        question.body = nil
        question.should have(1).errors_on(:body)
      end

      it "should at least 30 characters" do
        question = Factory.build(:question)
        question.body = "Lorem ipsum dolor sit nullam."
        question.should have(1).errors_on(:body)
      end
    end
  end

  describe "scopes" do
    before(:each) do
      @questions = []
      3.times do |i|
        @questions << Factory(:question)
      end
      @questions[1].destroy # Delete the middle item
    end

    it "default scope should not return deleted items" do
      questions = Question.all
      questions.size.should == 2
      questions.should_not include(@questions[1])
    end

    it "deleted 'scope' should return only deleted items" do
      questions = Question.deleted.all
      questions.size.should == 1
      questions.should include(@questions[1])
    end
  end
end
