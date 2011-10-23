require 'spec_helper'

describe Tagging do
  it "has a valid factory" do
    Factory(:tagging).should be_valid
  end
  
  describe "associations" do
    it { should belong_to(:question) }
    it { should belong_to(:tag) }
  end

  describe "validation" do
    it { should validate_presence_of(:question_id) }
    it { should validate_numericality_of(:question_id) }
    it { should validate_presence_of(:tag_id) }
    it { should validate_numericality_of(:tag_id) }
  end
end
