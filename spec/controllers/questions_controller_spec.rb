require 'spec_helper'

describe QuestionsController do
  context 'index' do
    before do
      get :index
    end

    it { should respond_with(:success) }
  end
end