require 'spec_helper'

describe QuestionsController do
  describe 'GET index' do
    it "successfully responds" do
      get :index
      response.status.should == 200
    end

    it 'should assign @questions' do
      get :index
      assigns[:questions].should_not be_nil
    end
  end
  
  describe 'GET show' do
    before do
      @question = Factory(:question)
      get :show, :id => @question.id
    end

    it "should successfully respond" do
      response.status.should == 200
    end

    it "should assign @question" do
      assigns(:question).id.should == @question.id
    end

    it "should assign @answers" do
      assigns(:answers).should_not be_nil
    end

    it "should assign @answer to a new Answer" do
      assigns(:answer).should be_a_new(Answer)
    end
  end

  describe 'GET revisions' do
    before(:each) do
      @question = Factory(:question)
      get :revisions, :id => @question.id
    end

    it "should successfully respond" do
      response.status.should == 200
    end

    it "should assign question" do
      assigns(:question).id.should == @question.id
    end

    it "should assign versions" do
      assigns(:revisions).should_not be_nil
    end
  end

  describe 'when logged in as a user,' do
    before(:each) do
      login_as(Factory(:user))
      get :new
    end

    describe 'GET new' do
      it "should successfully respond" do
        response.status.should == 200
      end

      it "should assign a new question to @question" do
        assigns(:question).should be_a_new(Question)
      end
    end

    describe 'POST create' do
      describe 'with a valid question' do
        before(:each) do
          post :create, :question => Factory.attributes_for(:question)
        end

        it "should successfully respond" do
          question = assigns(:question)
          response.should redirect_to(question_path(question))
        end

        it "should set the flash" do
          flash[:notice].should == "Successfully created question."
        end
      end

      describe 'with a invalid question' do
        before(:each) do
          post :create, :question => {}
        end

        it "should render the new action" do
          response.should render_template("questions/new")
        end
      end
    end
    
    describe 'GET edit' do
      before(:each) do
        @question = Factory(:question)
      end

      it "should " do
      end
    end
  end
  
  describe 'when not logged in,' do
    before(:each) do
      logout
    end

    describe 'GET new' do
      it "should redirect to the login url" do
        get :new
        response.should redirect_to(login_path)
      end
    end

    describe 'POST create' do
      it "should redirect to the login url" do
        post :create
        response.should redirect_to(login_path)
      end
    end
    
    describe 'GET edit' do
      it "should redirect to the login url" do
        @question = Factory(:question)
        get :edit, :id => @question.id
        response.should redirect_to(login_path)
      end
    end

    describe 'PUT update' do
      it "should redirect to the login url" do
        @question = Factory(:question)
        put :update, :id => @question.id
        response.should redirect_to(login_path)
      end
    end

    describe 'DELETE destroy' do
      it "should redirect to the login url" do
        @question = Factory(:question)
        delete :destroy, :id => @question.id
        response.should redirect_to(login_path)
      end
    end
  end
end
