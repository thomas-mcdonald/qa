require 'spec_helper'

describe Authorization do
  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'mass assignment' do
    it { should_not allow_mass_assignment_of(:user_id) }
  end
end