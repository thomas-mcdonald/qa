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
      Example.slug_attr.should == :attr1
    end
  end

  context 'to_param' do
    it 'sets to_param' do
      Example.new.should respond_to(:to_param)
    end

    it 'is a combination of id and slug' do
      e = Example.new
      e.attr1 = 'test'
      e.to_param.should == 'stub/test'
    end
  end
end