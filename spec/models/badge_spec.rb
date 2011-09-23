require 'spec_helper'

describe Badge do
  it "has a valid factory" do
    Factory(:badge).should be_valid
  end

  describe "validation" do
    describe "of token" do
      it "requires presence" do
        badge = Factory.build(:badge)
        badge.token = nil
        badge.should have(1).errors_on(:token)
      end
    end

    describe "of user_id" do
      it "validates numericality" do
        badge = Factory.build(:badge)
        badge.user_id = "ab"
        badge.should have(1).errors_on(:user_id)
        badge.user_id = nil
        badge.should have(1).errors_on(:user_id)
        badge.user_id = 1
        badge.should have(0).errors_on(:user_id)
      end
    end
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
      badge = Factory.build(:badge)
      badge.token = 'nice_answer'
      badge.save

      Badge.param_token('nice-answer').should include(badge)
    end

    it "should not return results with the parametized token" do
      badge = Factory.build(:badge)
      badge.token = 'nice-answer'
      badge.save(:validate => false)

      Badge.param_token('nice-answer').should_not include(badge)
    end

    it "should not return results with different tokens" do
      badge = Factory.build(:badge)
      badge.token = 'great_answer'
      badge.save

      Badge.param_token('nice-answer').should_not include(badge)
    end
  end

  describe ".user" do
    it "should return results from a particular user" do
      badge = Factory(:badge)
      Badge.user(badge.user).should include(badge)
    end

    it "should not return results from a different user" do
      badge = Factory(:badge)
      Badge.user(Factory(:user)).should_not include(badge)
    end
  end

  describe "#shallow?" do
    it "should return false if not otherwise defined" do
      badge = Factory(:badge)
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
end

