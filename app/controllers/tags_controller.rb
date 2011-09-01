class TagsController < ApplicationController
  def index
    @tags = Tag.order('taggings_count DESC').limit(75)
  end
end