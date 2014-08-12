require 'spec_helper'

describe CommentPolicy do
  subject { CommentPolicy }

  permissions :new? do
    it 'requires a user' do
      comment = FactoryGirl.build(:comment, user: nil)
      is_expected.not_to permit(nil, comment)
    end

    it 'allows if user is staff' do
      user = FactoryGirl.create(:user, admin: true)
      comment = FactoryGirl.build(:comment, user: user)
      is_expected.to permit(user, comment)
    end

    it 'denies if the user does not have the required reputation' do
      user = FactoryGirl.create(:user, reputation: 0)
      comment = FactoryGirl.create(:comment, user: user)
      is_expected.not_to permit(user, comment)
    end

    it 'allows if the user has enough reputation' do
      user = FactoryGirl.create(:user, reputation: ReputationRequirements.comment.create + 1)
      comment = FactoryGirl.build(:comment, user: user)
      is_expected.to permit(user, comment)
    end
  end
end
