class QuestionsController < ApplicationController
  before_filter :require_login, except: [:index, :show, :tagged]
  before_filter :load_and_verify_slug, only: [:show]

  def index
    @questions = Question.includes(:last_active_user, :tags).page(params[:page]).load
  end

  def tagged
    @questions = Question.tagged_with(params[:tag]).includes(:last_active_user, :tags).page(params[:page])
    @count = Question.tagged_with(params[:tag]).count
    @related_tags = Tag.named(params[:tag]).related_tags
  end

  def show
    @question.viewed_by(request.remote_ip)
    @answers = @question.answers.includes(:user).question_view_ordering(@question)
    @user_votes = @question.votes_on_self_and_answers_by_user(current_user)
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.update_last_activity(current_user)
    @question.user = current_user
    if @question.save
      redirect_to @question
    else
      render 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    @question.update_attributes!(question_params)
    @question.update_last_activity(current_user)
    @question.save
    redirect_to @question
  end

  def accept_answer
    # TODO: this method requires refactoring
    # TODO: reputation events need destroying on new accepted answers
    @question = Question.find(params[:id])
    require_user(@question.user)
    if params[:answer_id].blank? and @question.accepted_answer_id.blank?
      head :bad_request and return
    end
    if params[:answer_id].present? # setting new accept
      @answer = Answer.find(params[:answer_id])
      @question.accept_answer(@answer)
    else # removing an existing accept
      @answer = Answer.find(@question.accepted_answer_id)
      @question.unaccept_answer
    end
    if @question.save
      render json: {
        content: render_to_string(partial: 'answers/accept_answer', layout: false, locals: { question: @question, answer: @answer })
      }
    else
      render json: { error: 'Nope, not doing that' } # TODO: properly handle
    end
  end

  private

  def load_and_verify_slug
    @question = Question.includes(:votes).find(params[:id])
    if params[:slug] != @question.slug
      redirect_to @question
    end
  end

  def question_params
    params.require(:question).permit(:body, :tag_list, :title)
  end
end