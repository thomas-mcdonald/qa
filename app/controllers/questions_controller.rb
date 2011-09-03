class QuestionsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :revisions, :tagged]
  
  def index
    @questions = Question.question_list_includes.page(params[:page])
    @recent_tags = Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).where('taggings.created_at > ?', 7.days.ago).group('taggings.tag_id').order('count(taggings.tag_id) DESC').limit(10).all
  end

  def tagged
    @tag = Tag.where('name = ?', params[:tag]).first
    @question_count = Question.tagged(params[:tag]).count
    @questions = Question.tagged(params[:tag]).question_list_includes.page(params[:page])
  end

  def show
    @question = Question.includes(:tags, :user).find(params[:id])
    @answers = @question.answers.includes(:votes).page(params[:page])
    @answer = Answer.new
  end

  def revisions
    @question = Question.find(params[:id])
    @revisions = @question.versions
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params[:question])
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
  end

  def update
    @question = Question.find(params[:id])
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
    @question.destroy
    redirect_to questions_url, :notice => "Successfully destroyed question."
  end
end
