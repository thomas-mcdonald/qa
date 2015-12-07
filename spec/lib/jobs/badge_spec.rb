require 'spec_helper'
require 'jobs/badge'

module BadgeFixtures
  class Easy < QA::BadgeDefinition::Base
    @check_on = :award_test
    @name = :easy
    @type = :bronze
    @unique = false

    def check(_)
      true
    end
  end

  class Impossible < QA::BadgeDefinition::Base
    @check_on = :criteria_test
    @name = :impossible
    @type = :bronze

    def check(_)
      false
    end
  end

  class Unique < QA::BadgeDefinition::Base
    @check_on = :unique_test
    @name = :unique
    @type = :bronze

    def check(_)
      true
    end
  end
end

describe Jobs::Badge do
  before do
    QA::BadgeManager.namespace = BadgeFixtures
  end
  let(:question) { FactoryGirl.create(:question, user: user) }
  let(:other_question) { FactoryGirl.create(:question, user: user) }
  let(:user) { FactoryGirl.create(:user) }

  it 'awards badges that meet the criteria' do
    expect do
      Jobs::Badge.new.perform('award_test', question.to_global_id)
    end.to change { user.badges.count }
    expect(user.badges.first.name).to eq(:easy)
  end

  it 'does not award if criteria not met' do
    expect do
      Jobs::Badge.new.perform('criteria_test', question.to_global_id)
    end.to_not change { user.badges.count }
  end

  it 'does not award unique badges twice' do
    user.badges << Badge.new(subject: question, name: 'unique')
    expect do
      Jobs::Badge.new.perform('unique_test', question.to_global_id)
    end.to_not change { user.badges.count }
  end

  it 'awards non-unique badges on different objects' do
    expect do
      Jobs::Badge.new.perform('award_test', question.to_global_id)
      Jobs::Badge.new.perform('award_test', other_question.to_global_id)
    end.to change { user.badges.count }.by(2)
  end

  it 'enforces object uniqueness on non-unique badges' do
    expect do
      Jobs::Badge.new.perform('award_test', question.to_global_id)
      Jobs::Badge.new.perform('award_test', question.to_global_id)
    end.to change { user.badges.count }.by(1)
  end
end
