require 'spec_helper'

describe User do
  context 'associations' do
    it { should have_many(:authorizations) }
  end

  describe 'display_name' do
    let(:user) { FactoryGirl.build(:user) }

    it 'does not change name for normal users' do
      user.name == user.display_name
    end

    it 'appends a ♦ for admins' do
      user.admin = true
      user.display_name.should include(user.name)
      user.display_name.should include('♦')
    end
  end

  describe 'email_hash' do
    before do
      @user = FactoryGirl.build(:user)
    end

    it 'should have a sane email hash' do
      @user.email_hash.should =~ /^[0-9a-f]{32}$/
    end

    it 'should use downcase email' do
      @user.email = "example@example.com"
      @user2 = FactoryGirl.build(:user)
      @user2.email = "ExAmPlE@eXaMpLe.com"

      @user.email_hash.should == @user2.email_hash
    end

    it 'should trim whitespace before hashing' do
      @user.email = "example@example.com"
      @user2 = FactoryGirl.build(:user)
      @user2.email = " example@example.com "

      @user.email_hash.should == @user2.email_hash
    end
  end
end
