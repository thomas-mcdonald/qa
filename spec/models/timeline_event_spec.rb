require 'spec_helper'

describe TimelineEvent do
  context 'associations' do
    it { should belong_to(:post) }
  end
end