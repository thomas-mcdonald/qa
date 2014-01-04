class TagsController < ApplicationController
  def index
    @tags = Tag.by_popularity.page(params[:page])
  end
end