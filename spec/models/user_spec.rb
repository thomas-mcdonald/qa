require 'spec_helper'

describe User, :type => :model do
  context 'associations' do
    it { is_expected.to have_many(:authorizations) }
    it { is_expected.to have_many(:reputation_events) }
  end

  describe '.new_from_hash' do
    let(:data) do
      {
        info: {
          email: 'test@example.com',
          name: 'John Doe'
        }
      }
    end

    it 'assigns based on email and name fields' do
      user = User.new_from_hash(data)
      expect(user.name).to eq(data[:info][:name])
      expect(user.email).to eq(data[:info][:email])
    end

    it 'does not assign other attributes' do
      data[:info][:admin] = true
      user = User.new_from_hash(data)
      expect(user.admin).to eq(false)
    end
  end

  describe 'calculate_reputation!' do
    let(:user) { FactoryGirl.create(:user) }

    it 'sums the total reputation events for the user' do
      ReputationEvent.create(
        action: FactoryGirl.create(:upvote),
        event_type: 1,
        user: user
      )
      user.calculate_reputation!
      expect(user.reputation).to eq(SiteSettings.reputation['receive_question_upvote'])
    end
  end

  describe 'display_name' do
    let(:user) { FactoryGirl.build(:user) }

    it 'does not change name for normal users' do
      user.name == user.display_name
    end

    it 'appends a ♦ for admins' do
      user.admin = true
      expect(user.display_name).to include(user.name)
      expect(user.display_name).to include('♦')
    end
  end

  describe 'email_hash' do
    before do
      @user = FactoryGirl.build(:user)
    end

    it 'should have a sane email hash' do
      expect(@user.email_hash).to match(/^[0-9a-f]{32}$/)
    end

    it 'should use downcase email' do
      @user.email = "example@example.com"
      @user2 = FactoryGirl.build(:user)
      @user2.email = "ExAmPlE@eXaMpLe.com"

      expect(@user.email_hash).to eq(@user2.email_hash)
    end

    it 'should trim whitespace before hashing' do
      @user.email = "example@example.com"
      @user2 = FactoryGirl.build(:user)
      @user2.email = " example@example.com "

      expect(@user.email_hash).to eq(@user2.email_hash)
    end
  end

  describe '.has_answered?' do
    let(:user) { FactoryGirl.create(:user) }

    it 'is true if the user has answered the question' do
      answer = FactoryGirl.create(:answer, user: user)
      expect(user.has_answered?(answer.question)).to be(true)
    end

    it 'is false if the user has not answered the question' do
      question = FactoryGirl.create(:question)
      expect(user.has_answered?(question)).to be(false)
    end
  end
end
