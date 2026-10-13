class TagsController < ApplicationController
  def index
    tags = Tag.joins(:articles).distinct.order(:name)
    render json: { tags: tags.pluck(:name) }
  end
end
