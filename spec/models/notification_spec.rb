require 'spec_helper'

describe Notification do
  it "should have a valid factory" do
    FactoryGirl.build(:notification).should be_valid
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
      n = FactoryGirl.create(:notification)
      Notification.dismiss!(n.id, n.user).should == true
    end

    it "should not dismiss notifications by a different user" do
      n = FactoryGirl.create(:notification)
      Notification.dismiss!(n.id, FactoryGirl.create(:user)).should == false
    end
  end

  describe "#dismiss" do
    it "should dismiss a notification" do
      n = FactoryGirl.create(:notification)
      n.dismiss!
      n.dismissed.should == true
    end
  end
end

