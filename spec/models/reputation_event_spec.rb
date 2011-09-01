require 'spec_helper'

describe ReputationEvent do
  it "has a valid factory" do
    Factory(:reputation_event).should be_valid
  end

  describe "validation" do
    describe "of user" do
      it "requires presence" do
        event = Factory.build(:reputation_event)
        event.user = nil
        event.should have(1).errors_on(:user)
      end
    end

    describe "of reputable" do
      it "requires presence" do
        event = Factory.build(:reputation_event)
        event.reputable = nil
        event.should have(1).errors_on(:reputable)
      end
    end

    describe "of value" do
      it "requires presence" do
        event = Factory.build(:reputation_event)
        event.value = nil
        event.should have(2).errors_on(:value)
      end

      it "requires numericality" do
        event = Factory.build(:reputation_event)
        event.value = "abd"
        event.should have(1).errors_on(:value)
      end
    end
  end
end
