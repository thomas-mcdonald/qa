require 'spec_helper'

describe QA::TimelineDiff do
  describe '#question?' do
    it 'returns true if the TimelineEvent refers to a question' do
      timeline_event = FactoryGirl.create(:timeline_event, :with_question)
      diff = QA::TimelineDiff.new(0, timeline_event, nil)
      expect(diff.question?).to be(true)

      timeline_event = FactoryGirl.create(:timeline_event, :with_answer)
      diff = QA::TimelineDiff.new(0, timeline_event, nil)
      expect(diff.question?).to be(false)
    end
  end
end
