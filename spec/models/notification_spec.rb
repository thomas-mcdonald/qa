require 'spec_helper'

describe Notification do
  it "should have a valid factory" do
    Factory.build(:notification).should be_valid
  end

  describe "validations" do
    describe "of token" do
      it "should require presence" do
        Factory.build(:notification, :token => nil).should_not be_valid
      end
    end

    describe "of user_id" do
      it "should validate numericality" do
        n = Factory.build(:notification)
        n.user_id = "abc"
        n.should have(1).errors_on(:user_id)
        n.user_id = nil
        n.should have(1).errors_on(:user_id)
        n.user_id = 123
        n.should have(0).errors_on(:user_id)
      end
    end
  end

  describe ".dismiss!" do
    it "should dismiss notifications for a particular user" do
      n = Factory(:notification)
      Notification.dismiss!(n.id, n.user).should == true
    end

    it "should not dismiss notifications by a different user" do
      n = Factory(:notification)
      Notification.dismiss!(n.id, Factory(:user)).should == false
    end
  end

  describe "#dismiss" do
    it "should dismiss a notification" do
      n = Factory(:notification)
      n.dismiss!
      n.dismissed.should == true
    end
  end
end

