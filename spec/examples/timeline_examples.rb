require 'spec_helper'

shared_examples_for 'timelined' do
  let(:item) { FactoryGirl.build(described_class.to_s.downcase.to_sym) }

  context 'create' do
    it 'creates a timeline event on new save' do
      item.save
      item.timeline_events.length.should == 1
      item.timeline_events.first.action.should == TimelineEvent::POST_CREATE
    end
  end
end