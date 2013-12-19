require 'spec_helper'

describe QuestionPolicy do
  subject { QuestionPolicy }

  permissions :edit? do
    it 'denies if the user has less than 1000 reputation' do
      user = FactoryGirl.create(:user, reputation: 0)
      question = FactoryGirl.create(:question)
      should_not permit(user, question)
    end
  end
end
