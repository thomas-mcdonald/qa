require 'spec_helper'

describe QuestionPolicy do
  subject { QuestionPolicy }

  permissions :edit? do
    it 'requires a user' do
      question = FactoryGirl.create(:question)
      is_expected.not_to permit(nil, question)
    end

    it 'denies if the user does not have the required reputation' do
      user = FactoryGirl.create(:user, reputation: 0)
      question = FactoryGirl.create(:question)
      is_expected.not_to permit(user, question)
    end
  end
end
