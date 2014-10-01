class TagsController < ApplicationController
  def index
    @tags = Tag.by_popularity.page(params[:page]).per(24)
  end

  def search
    @tags = Tag.by_popularity.search(params[:name]).limit(15)
    render json: @tags
  end
end