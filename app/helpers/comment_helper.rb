module CommentHelper
  def new_post_comment_url(post)
    new_comment_url(post_type: post.class, post_id: post.id)
  end
end
