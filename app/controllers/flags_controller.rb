class FlagsController < ApplicationController
  def new
    @item = Question.find(params[:question_id])
    render :new, :layout => false
  end
end

