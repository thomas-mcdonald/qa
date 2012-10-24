require 'spec_helper'

describe AnswersController do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @controller.stubs(:current_ability).returns(@ability)
  end

  before(:each) do
    @question = FactoryGirl.create(:question)
    @answer = FactoryGirl.attributes_for(:answer)
  end

  describe "as a logged in user" do
    before(:each) do
      login_as(FactoryGirl.create(:user))
    end

    describe "POST create" do
      it "should be successful" do
        post :create, :question_id => @question.id, :answer => @answer
        response.should redirect_to question_path(@question)
      end
    end

    describe "GET edit" do
      before(:each) do
        @answer = FactoryGirl.create(:answer)
      end

      describe "with update permission" do
        before(:each) do
          @ability.can :update, Answer
          get :edit, :id => @answer.id
        end

        it { should respond_with(:success) }
      end

      describe "without update permission" do
        before(:each) do
          @ability.cannot :update, Answer
          get :edit, :id => @answer.id
        end

        it { should respond_with(:forbidden) }  
      end
    end

    describe "PUT update" do
      before(:each) do
        @answer = FactoryGirl.create(:answer)
      end

      describe "with update permission" do
        before(:each) do
          @ability.can :update, Answer
          @answer.user_id = 12
          put :update, :id => @answer.id, :answer => @answer.attributes
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(@answer.question) }
        it "should update answer" do
          assigns(:answer).user_id.should == 12
        end
      end

      describe "without update permission" do
        before(:each) do
          @ability.cannot :update, Answer
          @answer.user_id = 12
          put :update, :id => @answer.id, :answer => @answer.attributes
        end

        it { should respond_with(:forbidden) }
        it "should not update answer" do
          assigns(:answer).user_id.should_not == 12
        end
      end
    end

    describe 'DELETE destroy' do
      before(:each) do
        @answer = FactoryGirl.create(:answer)
      end

      describe 'with delete permissions' do
        before(:each) do
          @ability.can :destroy, Answer
          delete :destroy, :id => @answer.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(@answer.question) }

        it "should soft-delete the answer" do
          assigns(:answer).deleted_at.should_not be_nil
        end
      end

      describe 'without delete permissions' do
        before(:each) do
          @ability.cannot :destroy, Answer
          delete :destroy, :id => @answer.id
        end

        it { should respond_with(:forbidden) }
        it "should not soft-delete the answer" do
          assigns(:answer).deleted_at.should be_nil
        end
      end
    end

    describe 'POST restore' do
      before(:each) do
        @answer = FactoryGirl.create(:answer)
        @answer.destroy
      end

      describe 'with restore permission' do
        before(:each) do
          @ability.can :restore, Answer
          post :restore, :id => @answer.id
        end

        it { should respond_with(:redirect) }
        it { should redirect_to(@answer.question) }
        it "should remove the soft-delete on the answer" do
          assigns(:answer).deleted_at.should be_nil
        end
      end

      describe 'without restore permission' do
        before(:each) do
          @ability.cannot :restore, Answer
          post :restore, :id => @answer.id
        end

        it { should respond_with(:forbidden) }
        it "should not change deleted_at" do
          assigns(:answer).deleted_at.should == @answer.deleted_at
        end
      end
    end
  end

  describe "when not logged in" do
    before(:each) do
      logout
    end

    describe 'POST create' do
      before(:each) do
        @question = FactoryGirl.create(:question)
        post :create, :question_id => @question.id
      end
      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end
    
    describe 'GET edit' do
      before(:each) do
        @answer = FactoryGirl.create(:answer)
        get :edit, :id => @answer.id
      end
      
      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end

    describe 'PUT update' do
      before(:each) do
        @answer = FactoryGirl.create(:answer)
        put :update, :id => @answer.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end

    describe 'DELETE destroy' do
      before(:each) do
        @answer = FactoryGirl.create(:answer)
        delete :destroy, :id => @answer.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end

    describe 'POST restore' do
      before(:each) do
        @answer = FactoryGirl.create(:answer)
        @answer.destroy
        post :restore, :id => @answer.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(login_path) }
    end
  end
end

