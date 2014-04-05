class AnswerCreator
  attr_reader :errors

  def initialize(question, user, params)
    raise ArgumentError unless question
    raise ArgumentError unless user
    @question = question
    @params = params
    @user = user
  end

  def create
    Answer.transaction do
      create_answer
      create_timeline_event
    end

    @answer
  end

  def create_answer
    @answer = @question.answers.new(@params)
    if !@answer.save
      @errors = @answer.errors
      raise ActiveRecord::Rollback
    end
  end

  def create_timeline_event
    @answer.create_timeline_event!
  end
end