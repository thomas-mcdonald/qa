class TagsController < ApplicationController
  def index
    @tags = Tag.by_popularity.page(params[:page]).per(24)
  end

  def search
    head :bad_request and return if invalid_search_param?
    @tags = Tag.by_popularity.search(params[:name]).limit(15)
    render json: @tags
  end

  private

  def invalid_search_param?
    params[:name].blank? || params[:name].length < 3
  end
end
