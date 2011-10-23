require 'spec_helper'

describe Notification do
  it "should have a valid factory" do
    Factory.build(:notification).should be_valid
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:token) }
    it { should validate_numericality_of(:user_id) }
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

