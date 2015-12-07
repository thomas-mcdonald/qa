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

    it 'formats numbers in a human readable way' do
      expect(views_formatted(1000)).to eq("1k")
      expect(views_formatted(1499)).to eq("1k")
      expect(views_formatted(1999)).to eq("2k")
      expect(views_formatted(1500)).to eq("2k")
      expect(views_formatted(2000)).to eq("2k")
      expect(views_formatted(9499)).to eq("9k")
      expect(views_formatted(9998)).to eq("10k")
      expect(views_formatted(19999)).to eq("20k")
      expect(views_formatted(99999)).to eq("100k")
      expect(views_formatted(199999)).to eq("200k")
      # numbers sub 1m don't get rounded up to 1m. we think this is okay.
      expect(views_formatted(999999)).to eq("1000k")
      expect(views_formatted(1000000)).to eq("1m")
      expect(views_formatted(1999500)).to eq("2m")
    end
  end
end