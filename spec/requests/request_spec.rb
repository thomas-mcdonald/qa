require 'spec_helper'

describe 'question url mapping', :type => :request do
  context 'show' do
    let(:question) { FactoryGirl.create(:question) }

    it 'validates the slug is correct' do
      route = "/questions/#{question.id}/blahincorrectslug"
      get route
      expect(response).to redirect_to(question)
    end
  end
end

describe 'user url mapping', :type => :request do
  context 'show' do
    let(:user) { FactoryGirl.create(:user) }

    it 'validates correct slug' do
      route = "/users/#{user.id}/incorrectslug"
      get route
      expect(response).to redirect_to(user)
    end
  end
end