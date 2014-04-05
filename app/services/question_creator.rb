class QuestionCreator
  attr_reader :errors

  def initialize(user, params)
    raise ArgumentError unless user
    @user = user
    @params = params
  end

  def create
    Question.transaction do
      create_question
      create_timeline_events
    end

    @question
  end

  def create_question
    @question = Question.new(@params)
    @question.user = @user
    @question.update_last_activity(@user)

    if !@question.save
      @errors = @question.errors
      raise ActiveRecord::Rollback
    end
  end

  def create_timeline_events
    @question.create_timeline_event!
  end
end
