require 'spec_helper'

describe Flag do
  it "should have a valid factory" do
    Factory.build(:flag).should be_valid
  end

  describe "validations" do
    describe "of user_id" do
      it "should validate numericality" do
        flag = Factory.build(:flag)
        flag.user_id = "abc"
        flag.should have(1).errors_on(:user_id)
        flag.user_id = nil
        flag.should have(1).errors_on(:user_id)
        flag.user_id = 1
        flag.should have(0).errors_on(:user_id)
      end
    end

    describe "of flaggable_id" do
      it "should validate numericality" do
        flag = Factory.build(:flag)
        flag.flaggable_id = "abc"
        flag.should have(1).errors_on(:flaggable_id)
        flag.flaggable_id = nil
        flag.should have(1).errors_on(:flaggable_id)
        flag.flaggable_id = 1
        flag.should have(0).errors_on(:flaggable_id)
      end
    end

    describe "of flaggable_type" do
      it "should validate presence" do
        flag = Factory.build(:flag)
        flag.flaggable_type = nil
        flag.should have(1).errors_on(:flaggable_type)
      end
    end
  end

  describe "#should_be_unique" do
    it "should add an error when a similar flag exists by the user" do
      flag = Factory(:flag)
      Flag.new(:user_id => flag.user_id, :flaggable => flag.flaggable).should have(1).errors_on(:flaggable)
    end

    it "should not add an error when a different user flags the same post" do
      flag = Factory(:flag)
      Flag.new(:user => Factory(:user), :flaggable => flag.flaggable).should have(0).errors_on(:flaggable)
    end

    it "should not add an error when a user flags a different post" do
      flag = Factory(:flag)
      Flag.new(:user => flag.user, :flaggable => Factory(:question)).should have(0).errors_on(:flaggable)
    end
  end

  describe "#dismiss!" do
    it "should dismiss a post when called" do
      flag = Factory(:flag)
      flag.dismiss!
      flag.dismissed.should == true
    end
  end
end

