require 'spec_helper'
require_dependency 'badge_manager'

class TestBase
  def self.check_on; @check_on; end
end

module BadgeSingle
  class One; end;
end

module BadgeDouble
  class One < TestBase; @check_on = :one; end;
  class Two < TestBase; @check_on = :two; end;
end

module BadgeBase
  class Base; end;
end

def setup_badge_manager(ns)
  QA::BadgeManager.instance_variable_set(:@namespace, ns)
  QA::BadgeManager.instance_variable_set(:@badges, nil)
end

describe QA::BadgeManager do
  subject { QA::BadgeManager }

  describe '.badges' do
    it 'returns the constants of the defined badges' do
      setup_badge_manager(BadgeSingle)
      expect(subject.badges).to eq([BadgeSingle::One])
      setup_badge_manager(BadgeDouble)
      expect(subject.badges).to eq([BadgeDouble::One, BadgeDouble::Two])
    end

    it 'ignores a base class' do
      setup_badge_manager(BadgeBase)
      expect(subject.badges).to eq([])
    end
  end

  describe '.badges_for' do
    it 'selects badges corresponding to that event' do
      setup_badge_manager(BadgeDouble)
      expect(subject.badges_for(:one)).to eq([BadgeDouble::One])
    end
  end
end
