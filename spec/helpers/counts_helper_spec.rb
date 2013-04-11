require 'spec_helper'

describe CountsHelper do
  describe 'view formatter' do
    it 'does not change numbers under 1000' do
      views_formatted(1).should == "1"
      views_formatted(10).should == "10"
      views_formatted(999).should == "999"
    end

    it 'changes numbers between 1000 and 1749 as 1k' do
      views_formatted(1000).should == "1k"
      views_formatted(1749).should == "1k"
    end

    it 'changes numbers between (x-1)750 and x749 as xk' do
      views_formatted(1750).should == "2k"
      views_formatted(2000).should == "2k"
      views_formatted(9745).should == "9k"
    end
  end
end