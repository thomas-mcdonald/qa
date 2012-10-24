require 'spec_helper'

describe UsersController do
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    User.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    post :create, :user => FactoryGirl.attributes_for(:user)
    response.should redirect_to(root_url)
    session['user_id'].should == assigns['user'].id
  end
end