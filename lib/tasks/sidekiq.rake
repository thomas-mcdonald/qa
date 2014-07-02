def deduplicate_queue(queue)
  seen = []
  struct_job = Struct.new(:klass, :args) unless defined?(SJob)
  queue.each do |job|
    j = struct_job.new(job.klass, job.args)
    if seen.include?(j)
      job.delete
    else
      seen << j
    end
  end
end

namespace :sidekiq do
  desc 'Remove duplicate jobs in the queue'
  task :deduplicate do
    require 'sidekiq/api'
    deduplicate_queue(Sidekiq::Queue.new)
    deduplicate_queue(Sidekiq::ScheduledSet.new)
  end
end
