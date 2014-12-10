require 'spec_helper'

describe AdminDashboard do
  subject { AdminDashboard.new }

  context 'sidekiq errors' do
    it 'detects if sidekiq workers are not running' do
      ps = Sidekiq::ProcessSet.any_instance
      ps.expects(:size).returns(0)
      expect(subject.problems.size).to be(1)
    end

    it 'does not insert if sidekiq is running' do
      Sidekiq::ProcessSet.any_instance.stubs(:size).returns(5)
      expect(subject.problems.size).to be(0)
    end
  end
end
