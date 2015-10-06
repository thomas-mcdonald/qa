module QA
  module Import
    class StackExchange
      # QA::Import::StackExchange::Comment represents a comment from a SE 2.0 data dump
      class Comment
        attr_accessor :body, :post_id, :user_id

        def initialize(row)
          @row = row
          @post_id = row['PostId'].to_i
          @body = row['Text']
          @user_id = row['UserId'].to_i
        end

        # Returns the new ::Comment object, given the post info as a Hash{:id, :type}
        def build_object(post)
          # return nil object if user does not exist
          return ::Comment.new unless User.exists?(user_id)
          ::Comment.new(
            post_id: post[:id],
            post_type: post[:type],
            body: body,
            user_id: user_id
          )
        end
      end
    end
  end
end