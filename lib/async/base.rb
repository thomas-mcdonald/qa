module Async
  class Base
    def self.create_badge(token, user, source)
      badge = Badge.create(
        :source => source,
        :token => token,
        :user => user
      )
      if badge.source == nil
        Notification.create(
          :token => 'new_badge_without_source',
          :parameters => {
            :badge_token => badge.token
          },
          :redirect => badge,
          :user => badge.user
        )
      else
        n = Notification.new(
          :parameters => {
            :badge_token => badge.token
          },
          :redirect => badge,
          :token => "new_badge_with_#{badge.source_type.downcase}_as_source",
          :user => badge.user
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

