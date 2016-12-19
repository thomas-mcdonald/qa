class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :name, :reputation, :profile_link

  def profile_link
    user_path(object)
  end
end
