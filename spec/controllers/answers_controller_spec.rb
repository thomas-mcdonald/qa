require 'spec_helper'

describe AnswersController do
  context 'create' do
    it 'requires login' do
      -> { post :create }.should raise_error(QA::NotLoggedIn)
    end
  end
end