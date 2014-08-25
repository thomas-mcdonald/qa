require 'spec_helper'

describe Tagging, :type => :model do
  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:tag) }
end