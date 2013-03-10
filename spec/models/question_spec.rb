require 'spec_helper'
require 'concerns/voteable_examples'

describe Question do
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:title).is_at_least(10).is_at_most(150) }

  it_should_behave_like 'voteable'
end