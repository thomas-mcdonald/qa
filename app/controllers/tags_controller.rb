class TagsController < ApplicationController
  def index
    @tags = Tag.by_popularity.page(params[:page]).per(24)
  end
end