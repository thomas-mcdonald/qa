require 'spec_helper'

describe Authorization do
  context 'associations' do
    it { should belong_to(:user) }
  end
end