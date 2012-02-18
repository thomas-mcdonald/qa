class QuestionsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :revisions, :tagged]
  
  def index
    # Can view deleted items?
    if logged_in? and current_user.can_view_deleted_items?
      @questions = Question.unscoped.activity_order.question_list_preloads.page(params[:page])
    else
      @questions = Question.question_list_preloads.page(params[:page])
    end
    @recent_tags = Tag.recent.all
    @recent_badges = Badge.recent.all
  end

  def tagged
    @tag = Tag.where('name = ?', params[:tag]).first
    # Can view deleted items?
    if logged_in? and current_user.can_view_deleted_items?
      @question_count = Question.unscoped.tagged(params[:tag]).count
      @questions = Question.unscoped.activity_order.tagged(params[:tag]).question_list_preloads.page(params[:page])
    else
      @question_count = Question.tagged(params[:tag]).count
      @questions = Question.tagged(params[:tag]).question_list_preloads.page(params[:page])
    end
  end

  def show
    @question = Question.includes({ :comments => :user }, :tags, :user).unscoped.find(params[:id])
    authorize! :read, @question
    @question.viewed_by(request.remote_ip)
    @answers = @question.answers.with_score.preload({ :comments => :user }, :user, :votes).page(params[:page]).all
    @answer = Answer.new
  end

  def revisions
    @question = Question.find(params[:id])
    @revisions = @question.versions.reverse
  end

  def new
    @question = Question.new
    authorize! :create, @question
  end

  def create
    @question = Question.new(params[:question])
    authorize! :create, @question
    @question.user = current_user
    @question.update_last_activity(current_user)
    if @question.save
      redirect_to @question, :notice => "Successfully created question."
    else
      render :action => 'new'
    end
  end

  def edit
    @question = Question.find(params[:id])
    authorize! :update, @question
  end

  def update
    @question = Question.find(params[:id])
    authorize! :update, @question
    @question.attributes = params[:question]
    @question.update_last_activity(current_user)
    if @question.save
      redirect_to @question, :notice  => "Successfully updated question."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    authorize! :destroy, @question
    @question.destroy
    redirect_to @question, :notice => "Successfully destroyed question."
  end

  def restore
    @question = Question.unscoped.find(params[:id])
    authorize! :restore, @question
    @question.deleted_at = nil
    @question.save
    redirect_to @question, :notice => "Restored question"
  end
end
