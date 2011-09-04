class VotesController < ApplicationController
  before_filter :require_vote_login
  
  def create
    @vote = Vote.new(params[:vote])
    @vote.value = params[:value]
    @vote.user = current_user
    if @vote.save
      Resque.enqueue(Async::Badges.const_get("Create#{@vote.voteable_type}Vote"), @vote.id)
      Rails.logger.info("Queued #{@vote.voteable_type} vote for processing")
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
