require_dependency 'question_creator'
require_dependency 'timeline_action'

class QuestionsController < ApplicationController
  include TimelineAction

  before_action :require_login, except: [:index, :show, :tagged, :timeline]
  before_action :ensure_valid_accept_modifier, only: [:accept_answer, :unaccept_answer]
  before_action :load_and_verify_slug, only: [:show]
  before_action :set_active_tab, only: [:index, :tagged]

  def index
    return render_404 unless valid_sort_param
    @questions = Question.sorted(params[:sort]).includes(:last_active_user, :tags).page(params[:page]).load
    @recent_badges = Badge.order('created_at DESC').includes(:user).limit(10)
  end

  def tagged
    return render_404 unless valid_sort_param
    @tag = Tag.find_by(name: params[:tag])
    @questions = Question.tagged_with(params[:tag]).sorted(params[:sort]).includes(:last_active_user, :tags).page(params[:page])
    @count = Question.tagged_with(params[:tag]).count
    @related_tags = Tag.named(params[:tag]).related_tags
  end

  def show
    @question.viewed_by(request.remote_ip)
    @answer_count = @question.answers.count
    @answers = @question.answers.includes(:user, comments: :user).question_view_ordering(@question).page(params[:page]).per(5)
    @user_votes = @question.votes_on_self_and_answers_by_user(current_user)
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    creator = QuestionCreator.new(current_user, question_params)
    @question = creator.create
    if creator.errors.blank?
      redirect_to @question
    else
      render 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
    authorize(@question)
  end

  def update
    @question = Question.find(params[:id])
    authorize(@question)
    @question.update_attributes!(question_params)
    @question.update_last_activity(current_user)
    @question.edit_timeline_event!(current_user)
    @question.save
    redirect_to @question
  end

  def accept_answer
    # TODO: reputation events need destroying on new accepted answers
    head :bad_request and return if params[:answer_id].blank?
    @question.unaccept_answer
    @answer = Answer.find(params[:answer_id])
    @question.accept_answer(@answer)
    if @question.save
      render_json_partial('answers/accept_answer', {
        question: @question,
        answer: @answer
      })
    else
      render json: { error: 'Nope, not doing that' } # TODO: properly handle
    end
  end

  def unaccept_answer
    @answer = @question.accepted_answer
    @question.unaccept_answer
    @question.save
    render_json_partial('answers/accept_answer', {
      answer: @answer,
      question: @question
    })
  end

  private

  def ensure_valid_accept_modifier
    @question = Question.find(params[:id])
    head :forbidden unless is_user(@question.user)
  end

  def load_timeline_post
    @post = Question.find(params[:id])
  end

  def load_and_verify_slug
    @question = Question.includes(:votes, :user, comments: :user).find(params[:id])
    if !@question.valid_slug?(params[:id])
      redirect_to @question
    end
  end

  def question_params
    params.require(:question).permit(:body, :tag_list, :title)
  end

  def set_active_tab
    @active_tab = (params[:sort] || :activity).to_sym
  end

  def valid_sort_param
    params[:sort].nil? or Question::VALID_SORT_KEYS.include?(params[:sort].to_sym)
  end
end
