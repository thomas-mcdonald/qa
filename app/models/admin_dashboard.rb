class AdminDashboard
  def stats
    {
      questions: {
        week: Question.past_week.count,
        month: Question.past_month.count,
        year: Question.past_year.count
      },
      answers: {
        week: Answer.past_week.count,
        month: Answer.past_month.count,
        year: Answer.past_year.count
      }
    }
  end

  def problems
    [sidekiq].compact
  end

  def problems?
    problems.length > 0
  end

  private

  def sidekiq
    'No Sidekiq workers appear to be available. Is Sidekiq running?' if Sidekiq::ProcessSet.new.size == 0
  end
end
