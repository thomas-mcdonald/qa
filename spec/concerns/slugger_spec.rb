require 'spec_helper'
require 'slugger'

class Example
  attr_accessor :attr1

  include QA::Slugger
  is_slugged :attr1

  def id; 'stub'; end
end

describe QA::Slugger do
  context 'is slugged' do
    it 'sets slug_attr' do
      expect(Example.slug_attr).to eq(:attr1)
    end
  end

  context 'to_param' do
    it 'sets to_param' do
      expect(Example.new).to respond_to(:to_param)
    end

    it 'is a combination of id and slug' do
      e = Example.new
      e.attr1 = 'test'
      expect(e.to_param).to eq('stub-test')
    end
  end
end
