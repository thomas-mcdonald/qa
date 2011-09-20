class FlagsController < ApplicationController
  before_filter :login_required

  def new
    @item = Question.find(params[:question_id])
    render :new, :layout => false
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
end

