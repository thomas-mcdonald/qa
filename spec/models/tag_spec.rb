require 'spec_helper'

def tag_finder(name)
  Tag.where(name: name).first
end

describe Tag, :type => :model do
  it { is_expected.to have_many(:taggings) }
  it { is_expected.to have_many(:questions) }

  describe '.popularity' do
    it 'orders tags by their usage count' do
      FactoryGirl.create(:question, tag_list: 'foo, bar')
      FactoryGirl.create(:question, tag_list: 'foo')
      expect(Tag.by_popularity).to eq([tag_finder('foo'), tag_finder('bar')])
    end
  end

  describe '.named' do
    let(:tag) { FactoryGirl.create(:tag) }

    it 'returns the tag named as parameter' do
      expect(tag).to eq(Tag.named(tag.name))
    end
  end

  describe '#related' do
    it 'find related tags by checking questions with that tag' do
      FactoryGirl.create(:question, tag_list: 'cat, join-tag')
      FactoryGirl.create(:question, tag_list: 'dog, join-tag')
      related = tag_finder('join-tag').related_tags
      expect(related).to include(tag_finder('dog'))
      expect(related).to include(tag_finder('cat'))
      crelated = tag_finder('cat').related_tags
      expect(crelated).to include(tag_finder('join-tag'))
      expect(crelated).not_to include(tag_finder('dog'))
    end
  end
end
