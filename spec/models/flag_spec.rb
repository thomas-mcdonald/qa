require 'spec_helper'

describe Flag do
  it "should have a valid factory" do
    FactoryGirl.build(:flag).should be_valid
  end

  describe "assocations" do
    it { should belong_to(:flaggable) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_numericality_of(:user_id) }
    it { should validate_numericality_of(:flaggable_id) }
    it { should validate_presence_of(:flaggable_type) }
    it { should validate_presence_of(:reason) }
  end

  describe "#should_be_unique" do
    it "should add an error when a similar flag exists by the user" do
      flag = FactoryGirl.create(:flag)
      Flag.new(:user_id => flag.user_id, :flaggable => flag.flaggable).should have(1).errors_on(:flaggable)
    end

    it "should not add an error when a different user flags the same post" do
      flag = FactoryGirl.create(:flag)
      Flag.new(:user => FactoryGirl.create(:user), :flaggable => flag.flaggable).should have(0).errors_on(:flaggable)
    end

    it "should not add an error when a user flags a different post" do
      flag = FactoryGirl.create(:flag)
      Flag.new(:user => flag.user, :flaggable => FactoryGirl.create(:question)).should have(0).errors_on(:flaggable)
    end
  end

  describe "#dismiss!" do
    it "should dismiss a post when called" do
      flag = FactoryGirl.create(:flag)
      flag.dismiss!
      flag.dismissed.should == true
    end
  end
end

