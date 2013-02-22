require 'spec_helper'

describe 'question url mapping' do
  context 'show' do
    let(:question) { FactoryGirl.create(:question) }

    it 'validates the slug is correct', type: :request do
      route = "/questions/#{question.id}/blahincorrectslug"
      get route
      expect(response).to redirect_to(question)
    end
  end
end