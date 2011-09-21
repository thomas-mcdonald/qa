require 'spec_helper'

describe "routes for answers" do
  it "routes post on /question/:question_id/answers as question_answers_path" do
    { :post => "/questions/1/answers" }.should route_to(:controller => "answers", :action => "create", :question_id => "1")
    { :post => question_answers_path(1) }.should route_to(:controller => "answers", :action => "create", :question_id => "1")
  end
end

