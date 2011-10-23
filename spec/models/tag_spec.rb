require 'spec_helper'

describe Tag do
  it "has a valid factory" do
    Factory(:tag).should be_valid
  end

  describe "associations" do
    it { should have_many(:taggings) }
    it { should have_many(:questions).through(:taggings) }
  end

  describe "validation" do
    it { should validate_presence_of(:name) }
  end
end
