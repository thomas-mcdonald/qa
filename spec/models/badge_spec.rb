require 'spec_helper'

describe Badge do
  it "has a valid factory" do
    FactoryGirl.create(:badge).should be_valid
  end

  describe "associations" do
    it { should belong_to(:source) }
    it { should belong_to(:user) }
  end

  describe "validation" do
    it { should validate_presence_of(:token) }
    it { should validate_numericality_of(:user_id) }
  end

  describe ".all_badges" do
    it "should provide an array of all badges" do
      Badge.all_badges.class.should == Array
    end
  end

  describe ".new_from_param" do
    it "should create a 'shallow' badge given a parameter formatted token" do
      badge = Badge.new_from_param('nice-answer')
      badge.shallow?.should == true
      badge.token.should == 'nice_answer'
      badge.user.should == nil
    end
  end

  describe ".new_from_token" do
    it "should create a 'shallow' badge given a token to Badge#new_from_token" do
      badge = Badge.new_from_token('nice_answer')
      badge.shallow?.should == true
      badge.token.should == 'nice_answer'
      badge.user.should == nil
    end
  end

  describe ".param_token" do
    it "should return results with the tokenized token" do
      badge = FactoryGirl.create(:badge, :token => 'nice_answer')

      Badge.param_token('nice-answer').should include(badge)
    end

    it "should not return results with the parametized token" do
      badge = FactoryGirl.build(:badge, :token => "nice-answer")
      badge.save(:validate => false)

      Badge.param_token('nice-answer').should_not include(badge)
    end

    it "should not return results with different tokens" do
      badge = FactoryGirl.create(:badge, :token => 'great_answer')

      Badge.param_token('nice-answer').should_not include(badge)
    end
  end

  describe ".user" do
    it "should return results from a particular user" do
      badge = FactoryGirl.create(:badge)
      Badge.user(badge.user).should include(badge)
    end

    it "should not return results from a different user" do
      badge = FactoryGirl.create(:badge)
      Badge.user(FactoryGirl.create(:user)).should_not include(badge)
    end
  end

  describe "#shallow?" do
    it "should return false if not otherwise defined" do
      badge = FactoryGirl.create(:badge)
      badge.shallow?.should == false
    end

    it "should return true is shallow is true" do
      badge = Badge.new(:shallow => true)
      badge.shallow?.should == true
    end
  end

  describe ".inverse_param" do
    it "should return the tokenized form of a token parameter" do
      Badge.inverse_param("nice-answer").should == "nice_answer"
      Badge.inverse_param("double-hyphen-test").should == "double_hyphen_test"
    end
  end

  describe "#to_param" do
    it "should return the parameterized form of a the badges token" do
      Badge.new(:token => 'nice_answer').to_param.should == "nice-answer"
      Badge.new(:token => 'double_underscore_test').to_param.should == "double-underscore-test"
    end
  end

  describe "#type" do
    it "should return the type of a particular badge" do
      Badge.new(:token => 'nice_answer').type.should == "bronze"
      Badge.new(:token => 'good_answer').type.should == "silver"
      Badge.new(:token => 'great_answer').type.should == "gold"
    end
  end

  describe "#name" do
    it "should return the i18n string" do
      Badge.new(:token => 'nice_answer').name.should == I18n.t("badges.nice_answer.name")
    end
  end

  describe "#description" do
    it "should return the i18n string" do
      Badge.new(:token => 'nice_answer').description.should == I18n.t("badges.nice_answer.description")
    end
  end
end

