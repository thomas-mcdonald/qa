require 'spec_helper'

describe CountsHelper, :type => :helper do
  describe 'rep formatter' do
    it 'does not change numbers under 1000' do
      expect(rep_formatted(1)).to eq("1")
      expect(rep_formatted(10)).to eq("10")
      expect(rep_formatted(999)).to eq("999")
    end

    it 'inserts delimiters for numbers between 1000 and 9999' do
      expect(rep_formatted(1000)).to eq("1,000")
      expect(rep_formatted(9999)).to eq("9,999")
    end

    it 'displays the first hundred reputation of a thousand without decimals' do
      expect(rep_formatted(10000)).to eq("10k")
      expect(rep_formatted(95000)).to eq("95k")
    end

    it 'inserts decimals and shortens for thousands' do
      expect(rep_formatted(11100)).to eq("11.1k")
      expect(rep_formatted(55500)).to eq("55.5k")
      expect(rep_formatted(99999)).to eq("99.9k")
    end

    it 'handles 100ks' do
      expect(rep_formatted(100000)).to eq("100k")
      expect(rep_formatted(123456)).to eq("123k")
    end

    it 'displays gt 1m for values over 1 million' do
      expect(rep_formatted(1000000)).to eq("> 1m")
    end

    it 'displays negatives' do
      expect(rep_formatted(-100)).to eq('-100')
    end
  end

  describe 'view formatter' do
    it 'does not change numbers under 1000' do
      expect(views_formatted(1)).to eq("1")
      expect(views_formatted(10)).to eq("10")
      expect(views_formatted(999)).to eq("999")
    end

    it 'changes numbers between 1000 and 1749 as 1k' do
      expect(views_formatted(1000)).to eq("1k")
      expect(views_formatted(1749)).to eq("1k")
    end

    it 'changes numbers between (x-1)750 and x749 as xk' do
      expect(views_formatted(1750)).to eq("2k")
      expect(views_formatted(2000)).to eq("2k")
      expect(views_formatted(9745)).to eq("9k")
    end
  end
end