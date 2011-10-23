require 'spec_helper'

describe QuestionsController do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stubs(:current_ability).returns(@ability)
  end

  describe 'GET index' do
    before(:each) do
      get :index
    end

    it { should respond_with(:success) }
    it { should assign_to(:questions) }
    it { should render_template(:index) }
  end
  
  describe 'GET show' do
    before(:each) do
      @question = Factory(:question)
    end

    describe 'with permission' do
      before(:each) do
        @ability.can :read, Question
        get :show, :id => @question.id
      end

      it { should respond_with(:success) }
      it { should assign_to(:question).with(@question) }
      it { should assign_to(:answers) }
      it { should assign_to(:answer).with_kind_of(Answer) }
      it { should render_template(:show) }
    end

    describe 'without permission' do
      before(:each) do
        @ability.cannot :read, Question
        get :show, :id => @question.id
      end

      it { should respond_with(:forbidden) }
    end
  end

  describe 'GET revisions' do
    before(:each) do
      @question = Factory(:question)
      get :revisions, :id => @question.id
    end

    it { should respond_with(:success) }
    it { should assign_to(:question).with(@question) }
    it { should assign_to(:revisions) }
    it { should render_template(:revisions) }
  end

  describe 'GET tagged' do
    before(:each) do
      @question = Factory(:question)
      @tag = @question.tags.first
      get :tagged, :tag => @tag.name
    end

    it { should respond_with(:success) }
    it { should assign_to(:tag).with(@tag) }
    it { should assign_to(:questions) }
    it { should assign_to(:question_count) }
    it { should render_template(:tagged) }
  end

  describe 'when logged in as a user,' do
    before(:each) do
      login_as(Factory(:user))
    end

    describe 'GET new' do
      before(:each) do
        @ability.can :create, Question
        get :new
      end

      it { should respond_with(:success) }
      it { should assign_to(:question).with_kind_of(Question) }
      it { should render_template(:new) }
    end

    describe 'POST create' do
      before(:each) do
        @ability.can :create, Question
      end

      describe 'with a valid question' do
        before(:each) do
          post :create, :question => Factory.attributes_for(:question)
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(question_path(assigns(:question))) }
        it { should set_the_flash }
      end

      describe 'with a invalid question' do
        before(:each) do
          post :create, :question => {}
        end

        it { should respond_with(:success) }
        it { should render_template(:new) }
      end
    end
    
    describe 'GET edit' do
      before(:each) do
        @question = Factory(:question)
      end

      describe "with update permission" do
        before(:each) do
          @ability.can :update, Question
          get :edit, :id => @question.id
        end

        it { should respond_with(:success) }
        it { should assign_to(:question) }
        it { should render_template(:edit) }
      end

      describe "without update permission" do
        before(:each) do
          @ability.cannot :update, Question
          get :edit, :id => @question.id
        end

        it { should respond_with(:forbidden) }
      end
    end

    describe 'PUT update' do
      before(:each) do
        @question = Factory(:question)
      end

      describe "with update permission" do
        before(:each) do
          @ability.can :update, Question
          question = Factory.attributes_for(:question)
          question[:title] = "Changed title"
          put :update, :id => @question.id, :question => question
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(@question) }
      end

      describe "without update permission" do
        before(:each) do
          @ability.cannot :update, Question
          question = Factory.attributes_for(:question)
          question[:title] = "Changed title"
          put :update, :id => @question.id, :question => question
        end

        it { should respond_with(:forbidden) }
      end
    end

    describe 'DELETE destroy' do
      before(:each) do
        @question = Factory(:question)
      end

      describe 'with delete permissions' do
        before(:each) do
          @ability.can :destroy, Question
          delete :destroy, :id => @question.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(@question) }

        it "should soft-delete the question" do
          assigns(:question).deleted_at.should_not be_nil
        end
      end

      describe 'without delete permissions' do
        before(:each) do
          @ability.cannot :destroy, Question
          delete :destroy, :id => @question.id
        end

        it { should respond_with(:forbidden) }
        it "should not soft-delete the question" do
          assigns(:question).deleted_at.should be_nil
        end
      end
    end

    describe 'POST restore' do
      before(:each) do
        @question = Factory(:question)
        @question.destroy
      end

      describe 'with restore permission' do
        before(:each) do
          @ability.can :restore, Question
          post :restore, :id => @question.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(@question) }
        it "should remove the soft-delete on the question" do
          assigns(:question).deleted_at.should be_nil
        end
      end

      describe 'without restore permission' do
        before(:each) do
          @ability.cannot :restore, Question
          post :restore, :id => @question.id
        end

        it { should respond_with(:forbidden) }
        it "should not change deleted_at" do
          assigns(:question).deleted_at.should == @question.deleted_at
        end
      end
    end
  end
  
  describe 'when not logged in,' do
    before(:each) do
      logout
    end

    describe 'GET new' do
      before(:each) { get :new }
      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end

    describe 'POST create' do
      before(:each) { post :create }
      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end
    
    describe 'GET edit' do
      before(:each) do
        @question = Factory(:question)
        get :edit, :id => @question.id
      end
      
      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end

    describe 'PUT update' do
      before(:each) do
        @question = Factory(:question)
        put :update, :id => @question.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end

    describe 'DELETE destroy' do
      before(:each) do
        @question = Factory(:question)
        delete :destroy, :id => @question.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end

    describe 'POST restore' do
      before(:each) do
        @question = Factory(:question)
        @question.destroy
        post :restore, :id => @question.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end
  end
end
