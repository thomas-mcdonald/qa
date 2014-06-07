require 'spec_helper'

describe TagsController, :type => :controller do
  describe 'index' do
    it 'works' do
      get :index
      expect(response.status).to eq(200)
    end
  end
end