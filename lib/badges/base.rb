module Badges
  class Base
    def create_badge(token, user, source)
      badge = Badge.new
      badge.token = token
      badge.user = user
      badge.source = source
      badge.save
      badge
    end
  end
end
