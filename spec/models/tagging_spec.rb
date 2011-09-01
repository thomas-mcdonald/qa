require 'spec_helper'

describe Tagging do
  it "has a valid factory" do
    Factory(:tagging).should be_valid
  end

  describe "validation" do
    describe "question" do
      it "requires presence" do
        tagging = Factory.build(:tagging)
        tagging.question = nil
        tagging.should have(1).errors_on(:question_id)
      end
    end

    describe "tag" do
      it "requires presence" do
        tagging = Factory.build(:tagging)
        tagging.tag = nil
        tagging.should have(1).errors_on(:tag_id)
      end
    end
  end
end
