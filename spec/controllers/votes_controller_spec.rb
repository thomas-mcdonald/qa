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
      # TODO: should probably make this return unauthed
      it "should response with authorized (to stop JS from spitting failure)" do
        post :create
        response.status.should == 200
      end
    end
  end
end
