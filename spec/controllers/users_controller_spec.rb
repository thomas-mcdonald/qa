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

  describe 'edit' do
    before { sign_in(alice) }
    it 'loads successfully' do
      get :edit
      response.status.should == 200
    end
  end

  describe 'update' do
    before { sign_in(alice)}

    it 'rejects updates done by a different user' do
      -> { patch :update, id: bob.id, user: {name: 'Ed Balls'} }.should raise_error(QA::NotAuthorised)
    end

    it 'allows and updates if valid user' do
      patch :update, id: alice.id, user: { name: 'Ed Balls' }
      alice.reload.name.should == 'Ed Balls'
    end
  end
end