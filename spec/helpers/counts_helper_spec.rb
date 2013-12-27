require 'spec_helper'

describe CountsHelper do
  describe 'rep formatter' do
    it 'does not change numbers under 1000' do
      rep_formatted(1).should == "1"
      rep_formatted(10).should == "10"
      rep_formatted(999).should == "999"
    end

    it 'inserts delimiters for numbers between 1000 and 9999' do
      rep_formatted(1000).should == "1,000"
      rep_formatted(9999).should == "9,999"
    end

    it 'displays the first hundred reputation of a thousand without decimals' do
      rep_formatted(10000).should == "10k"
      rep_formatted(95000).should == "95k"
    end

    it 'inserts decimals and shortens for thousands' do
      rep_formatted(11100).should == "11.1k"
      rep_formatted(55500).should == "55.5k"
      rep_formatted(99999).should == "99.9k"
    end

    it 'handles 100ks' do
      rep_formatted(100000).should == "100k"
      rep_formatted(123456).should == "123k"
    end

    it 'displays gt 1m for values over 1 million' do
      rep_formatted(1000000).should == "> 1m"
    end

    it 'displays negatives' do
      rep_formatted(-100).should == '-100'
    end
  end

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