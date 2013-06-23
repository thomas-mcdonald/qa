require 'spec_helper'

describe TimelineActor do
  context 'associations' do
    it { should belong_to(:timeline_event) }
    it { should belong_to(:user) }
  end
end
