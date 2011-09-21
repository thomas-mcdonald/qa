module Async
  class Base
    def self.create_badge(token, user, source)
      badge = Badge.create(
        :source => source,
        :token => token,
        :user => user
      )
      if badge.source == nil
        badge.user.notify('new_badge_without_source', {
          :badge_token => badge.token
        }, badge)
      else
        n = badge.user.notifications.new(
          :parameters => {
            :badge_token => badge.token
          },
          :redirect => badge,
          :token => "new_badge_with_#{badge.source_type.downcase}_as_source"
        )
        case badge.source_type
        when "Question"
          n.parameters[:title] = badge.source.title
          n.parameters[:id] = badge.source.id
        when "Answer"
          n.parameters[:question_id] = badge.source.question.id
          n.parameters[:question_title] = badge.source.question.title
          n.parameters[:id] = badge.source.id
        end
        n.save
      end
      badge
    end
  end
end

