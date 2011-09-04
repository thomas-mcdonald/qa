class VotesController < ApplicationController
  before_filter :require_vote_login
  
  def create
    @vote = Vote.new(params[:vote])
    @vote.value = params[:value]
    @vote.user = current_user
    @vote.save
    if @vote.voteable_type == "Question"
      Resque.enqueue(Badges::CreateQuestionVote, @vote.voteable_id)
      Rails.logger.info("Queued question vote for processing")
    elsif @vote.voteable_type == "Answer"
      Resque.enqueue(Badges::CreateAnswerVote, @vote.voteable_id)
      Rails.logger.info("Queued answer vote for processing")
    end
    render :json => {
      :errors => @vote.errors,
      :vote => {
        :value => @vote.value
      }
    }
  end

  def destroy
    
  end
  
  private
  
  def require_vote_login
    if !logged_in?
      render :json => {
        :errors => {
          :message => "You need to be logged in to vote"
        }
      }, :status => 403 and return
    end
  end
end
