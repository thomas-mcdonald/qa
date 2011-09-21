class FlagsController < ApplicationController
  before_filter :login_required
  before_filter :moderator_required, :only => [:index, :dismiss]

  def index
    @flags = Flag.active.all
  end

  def new
    @item = Question.find(params[:question_id])
    if current_user.flags.where(:flaggable_id => @item.id, :flaggable_type => @item.class).first
      render :noflag, :layout => false
    else
      render :new, :layout => false
    end
  end

  def create
    @flag = current_user.flags.new
    @flag.flaggable_id = params[:flag][:flaggable_id]
    @flag.flaggable_type = params[:flag][:flaggable_type]
    @flag.reason = params[:flag][:reason]
    if @flag.save
      render :json => { :status => :ok, :message => "We'll take a look at your flag as soon as we can" }
    else
      render :json => { :status => :bad, :errors => @flag.errors }
    end
  end

  def dismiss
    @flag = Flag.find(params[:id])
    @flag.dismiss!
    redirect_to "/flags"
  end
end

