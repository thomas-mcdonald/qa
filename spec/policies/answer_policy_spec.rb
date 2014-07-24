require 'spec_helper'

describe AnswerPolicy do
  subject { AnswerPolicy }

  permissions :edit? do
    it 'requires a user' do
      answer = FactoryGirl.create(:answer)
      is_expected.not_to permit(nil, answer)
    end

    it 'allows if staff' do
      answer = FactoryGirl.create(:answer)
      # todo: this should probably just mock staff
      user = FactoryGirl.create(:user, admin: true)
      is_expected.to permit(user, answer)
    end

    it 'denies if the user does not have the required reputation' do
      user = FactoryGirl.create(:user, reputation: 0)
      answer = FactoryGirl.create(:answer)
      is_expected.not_to permit(user, answer)
    end
  end
end
