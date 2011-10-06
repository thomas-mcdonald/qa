class QuestionsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :revisions, :tagged]
  
  def index
    @questions = Question.question_list_includes.page(params[:page])
    @recent_tags = Tag.recent.all
    @recent_badges = Badge.recent.all
  end

  def tagged
    @tag = Tag.where('name = ?', params[:tag]).first
    @question_count = Question.tagged(params[:tag]).count
    @questions = Question.tagged(params[:tag]).preload(:last_active_user, :tags, :votes).page(params[:page])

  end

  def show
    @question = Question.includes(:tags, :user).unscoped.find(params[:id])
    authorize! :read, @question
    @question.viewed_by(request.remote_ip)
    @answers = @question.answers.includes(:votes).page(params[:page])
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
    redirect_to questions_url, :notice => "Successfully destroyed question."
  end
end
