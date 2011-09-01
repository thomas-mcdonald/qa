require 'spec_helper'

describe Tag do
  it "has a valid factory" do
    Factory(:tag).should be_valid
  end

  describe "validation on name" do
    it "requires presence" do
      tag = Factory.build(:tag)
      tag.name = nil
      tag.should have(1).errors_on(:name)
    end
  end
end
