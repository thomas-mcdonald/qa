require 'spec_helper'
require 'concerns/voteable_examples'

describe Answer do
  it_should_behave_like 'voteable'
end
