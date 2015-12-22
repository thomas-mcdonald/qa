class QuestionCreator
  attr_reader :errors

  def initialize(user, params)
    raise ArgumentError unless user
    if user.is_a? Integer
      @user = User.find(user)
    else
      @user = user
    end
    @params = params
  end

  def create
    Question.transaction do
      create_question
    end

    @question
  end

  def create_question
    @question = Question.new(@params)
    @question.user = @user
    @question.update_last_activity(@user)
    @question.create_timeline_event!

    if !@question.save
      @errors = @question.errors
      raise ActiveRecord::Rollback
    end
  end
end
