require 'spec_helper'

describe VotesController do
  describe "when logged in as a user," do
    before(:each) do
      login_as(Factory(:user))
    end

    describe "POST create" do
      it "should respond successfully" do

      end
    end
  end

  describe "when not logged in," do
    before(:each) do
      logout
    end

    describe "POST create" do
      it "should response with unauthorized" do
        post :create
        response.status.should == 403
      end
    end
  end
end
