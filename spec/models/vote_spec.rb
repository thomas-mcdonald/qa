require 'spec_helper'

describe Vote do
  context 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:user) }
  end
end