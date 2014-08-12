require 'spec_helper'

describe AdminDashboardProblems do
  subject { AdminDashboardProblems.new }

  context 'sidekiq errors' do
    it 'detects if sidekiq workers are not running' do
      workers = Sidekiq::Workers.any_instance
      workers.expects(:size).returns(0)
      expect(subject.problems.size).to be(1)
    end

    it 'does not insert if sidekiq is running' do
      Sidekiq::Workers.any_instance.stubs(:size).returns(5)
      expect(subject.problems.size).to be(0)
    end
  end
end
