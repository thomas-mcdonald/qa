require 'spec_helper'

describe AnswersController do
  before(:each) do
    @question = Factory(:question)
    @answer = Factory.attributes_for(:answer)
  end

  describe "as a logged in user" do
    before(:each) do
      login_as(Factory(:user))
    end

    describe "POST create" do
      it "should be successful" do
        post :create, :question_id => @question.id, :answer => @answer
        response.should redirect_to question_path(@question)
      end
    end

    describe "GET edit" do
      before(:each) do
        @answer = Factory(:answer)
      end

      it "should be successful" do
        get :edit, :id => @answer.id
        response.status.should == 200
      end
    end

    describe "PUT update" do
      describe "with a valid update" do
        it "should redirect to the question" do
          @answer = Factory(:answer)
          @answer.user_id = 10
          put :update, :id => @answer.id, :answer => @answer
          response.should redirect_to(@answer.question)
        end
      end

      describe "with an invalid update" do

      end
    end
  end
  
  describe "when not logged in" do
    before(:each) do
      logout
    end

    describe "POST create" do
      it "should require login" do
        post :create, :question_id => @question.id, :answer => @answer
        response.should redirect_to login_path
      end
    end
  end
end

