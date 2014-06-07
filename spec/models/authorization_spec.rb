require 'spec_helper'

describe Authorization, :type => :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end