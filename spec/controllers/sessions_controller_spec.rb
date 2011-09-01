require 'spec_helper'

describe SessionsController do
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when authentication is invalid" do
    user = Factory(:user)
    post :create, :login => user.username, :password => user.password + "wrong"
    response.should render_template(:new)
    session['user_id'].should be_nil
  end

  it "create action should redirect when authentication is valid" do
    user = Factory(:user)
    post :create, :login => user.username, :password => user.password
    response.should redirect_to(root_url)
    session['user_id'].should == User.first.id
  end
end