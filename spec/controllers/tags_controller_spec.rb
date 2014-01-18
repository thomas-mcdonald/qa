require 'spec_helper'

describe TagsController do
  describe 'index' do
    it 'works' do
      get :index
      response.status.should == 200
    end
  end
end