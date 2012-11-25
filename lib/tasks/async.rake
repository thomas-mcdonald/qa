namespace :async do
	task :all => :environment do
		Question.all.each { |q| Resque.enqueue(QA::Async::ResyncQuestion, q.id) }
		Answer.all.each { |a| Resque.enqueue(QA::Async::ResyncAnswer, a.id) }
		User.all.each { |u| Resque.enqueue(QA::Async::ReputationRecalc, u.id)}
	end
end