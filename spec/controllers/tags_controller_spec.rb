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
      get :search, xhr: true
      expect(response.status).to eq(400)

      get :search, params: { name: 'ab' }, xhr: true
      expect(response.status).to eq(400)
    end

    it 'returns tags if the query length is over 3' do
      get :search, params: { name: 'test-tag' }, xhr: true
      expect(response.status).to eq(200)
    end
  end
end
