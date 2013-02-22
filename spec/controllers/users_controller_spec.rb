require 'spec_helper'

describe UsersController do
  context 'show' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      get :show, id: user.id, slug: user.slug
    end

    it { should respond_with(:success) }
  end
end