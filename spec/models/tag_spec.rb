require 'spec_helper'

def tag_finder(name)
  Tag.where(name: name).first
end

describe Tag do
  it { should have_many(:taggings) }
  it { should have_many(:questions) }

  describe '.named' do
    let(:tag) { FactoryGirl.create(:tag) }

    it 'returns the tag named as parameter' do
      tag.should == Tag.named(tag.name)
    end
  end

  describe '#related' do
    it 'find related tags by checking questions with that tag' do
      q1 = FactoryGirl.create(:question, tag_list: 'cat, join-tag')
      q2 = FactoryGirl.create(:question, tag_list: 'dog, join-tag')
      related = tag_finder('join-tag').related_tags
      related.should include(tag_finder('dog'))
      related.should include(tag_finder('cat'))
      crelated = tag_finder('cat').related_tags
      crelated.should include(tag_finder('join-tag'))
      crelated.should_not include(tag_finder('dog'))
    end
  end
end