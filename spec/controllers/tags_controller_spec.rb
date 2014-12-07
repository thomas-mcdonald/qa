require 'spec_helper'

describe TagsController, type: :controller do
  describe 'index' do
    it 'works' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'search' do
    it 'returns bad request if query length under 3' do
      xhr :get, :search
      expect(response.status).to eq(400)

      xhr :get, :search, name: 'ab'
      expect(response.status).to eq(400)
    end

    it 'returns tags if the query length is over 3' do
      xhr :get, :search, name: 'test-tag'
      expect(response.status).to eq(200)
    end
  end
end
