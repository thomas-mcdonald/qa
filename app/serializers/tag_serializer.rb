class TagSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :link

  def link
    questions_tagged_url(tag: object.name)
  end
end
