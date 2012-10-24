require 'spec_helper'

describe ReputationEvent do
  it "has a valid factory" do
    FactoryGirl.create(:reputation_event).should be_valid
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:reputable) }
  end

  describe "validation" do
    it { should validate_presence_of(:reputable) }
    it { should validate_presence_of(:user_id) }
    it { should validate_numericality_of(:user_id) }
    it { should validate_presence_of(:value) }
    it { should validate_numericality_of(:value) }
  end
end
