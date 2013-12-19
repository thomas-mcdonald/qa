require 'spec_helper'

describe UsersController do
  describe 'show' do
    let(:user) { FactoryGirl.create(:user) }

    context 'with slug' do
      before do
        get :show, id: user.id, slug: user.slug
      end

      it { should respond_with(:success) }
    end

    it 'redirect if slug is incorrect or missing' do
      get :show, id: user.id
      response.status.should == 302
    end
  end
end
