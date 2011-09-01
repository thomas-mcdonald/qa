class TagsController < ApplicationController
  def index
    @tags = Tag.order('taggings_count DESC')
  end

  def show
    @questions_count = Question.joins(:tags).where('tags.name = ?', params[:id]).size
    @questions = Question.joins(:tags).where('tags.name = ?', params[:id]).page(params[:page])
  end
end