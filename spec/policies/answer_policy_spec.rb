require 'spec_helper'

describe AnswerPolicy do
  subject { AnswerPolicy }

  permissions :edit? do
    it 'requires a user' do
      answer = FactoryGirl.create(:answer)
      should_not permit(nil, answer)
    end

    it 'denies if the user does not have the required reputation' do
      user = FactoryGirl.create(:user, reputation: 0)
      answer = FactoryGirl.create(:answer)
      should_not permit(user, answer)
    end
  end
end
