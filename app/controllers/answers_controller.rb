require_dependency 'answer_creator'
require_dependency 'timeline_action'

class AnswersController < ApplicationController
  include TimelineAction

  before_filter :require_login, except: [:timeline]

  def create
    @question = Question.find(params[:answer][:question_id])
    creator = AnswerCreator.new(@question, current_user, answer_params)
    @answer = creator.create
    respond_to do |format|
      format.html do
        if creator.errors
          # TODO: handle html errors
        else
          redirect_to @answer.question
        end
      end
      format.json do
        if creator.errors
          render json: { errors: creator.errors }, status: 422
        else
          render_json_partial('answers/answer',
                  { answer: @answer, question: @question })
        end
      end
    end
  end

  def edit
    @answer = Answer.find(params[:id])
    authorize(@answer)
  end

  def update
    @answer = Answer.find(params[:id])
    authorize(@answer)
    @answer.update_attributes(answer_params)
    @answer.edit_timeline_event!(current_user)
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_timeline_post
    @post = Answer.find(params[:id])
  end
end
