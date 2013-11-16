require 'spec_helper'

describe Tag do
  it { should have_many(:taggings) }
  it { should have_many(:questions) }

  context '#named' do
    let(:tag) { FactoryGirl.create(:tag) }

    it 'returns the tag named as parameter' do
      tag.should == Tag.named(tag.name)
    end
  end
end