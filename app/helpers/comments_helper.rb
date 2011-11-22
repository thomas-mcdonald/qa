module CommentsHelper
  def comment_username(comment)
    comment.user ? link_to(comment.by, comment.user) : 'anonymous'
  end
end
