require 'active_support/concern'

module QA
  # LastActivity adds mixins for storing and updating the last activity on a
  # model.
  #
  # To do this it requires two attributes to be defined on the model:
  # last_active_user_id and last_active_at.
  #
  # This does not work through automatic callbacks, instead a call to the
  # method must be made in the controller since it requires more information
  # about who is doing the edit/update.
  module LastActivity
    extend ActiveSupport::Concern

    included do
      belongs_to :last_active_user, class_name: 'User', foreign_key: 'last_active_user_id'
    end

    def update_last_activity(user)
      self.last_active_user = user
      self.last_active_at = DateTime.current
    end
  end
end