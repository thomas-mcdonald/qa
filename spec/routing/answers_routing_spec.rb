require 'spec_helper'

describe "routes for answers" do
  it "routes /answers/:id/edit as edit_answer_path" do
    { :get => "/answers/1/edit" }.should route_to(:controller => "answers", :action => "edit", :id => "1")
    { :get => edit_answer_path(1) }.should route_to(:controller => "answers", :action => "edit", :id => "1")
  end

  it "routes post on /answers/:id/restore as restore_answer_path" do
    { :post => "/answers/1/restore" }.should route_to(:controller => "answers", :action => "restore", :id => "1")
    { :post => restore_answer_path(1) }.should route_to(:controller => "answers", :action => "restore", :id => "1")
  end

  it "routes delete on /answers/:id" do
    { :delete => "/answers/1" }.should route_to(:controller => "answers", :action => "destroy", :id => "1")
  end

  it "routes post on /question/:question_id/answers as question_answers_path" do
    { :post => "/questions/1/answers" }.should route_to(:controller => "answers", :action => "create", :question_id => "1")
    { :post => question_answers_path(1) }.should route_to(:controller => "answers", :action => "create", :question_id => "1")
  end
end

