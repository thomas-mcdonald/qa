require 'spec_helper'

describe Tagging do
  it { should belong_to(:question) }
  it { should belong_to(:tag) }
end