require 'spec_helper'

describe TimelineActor, :type => :model do
  context 'associations' do
    it { is_expected.to belong_to(:timeline_event) }
    it { is_expected.to belong_to(:user) }
  end
end
