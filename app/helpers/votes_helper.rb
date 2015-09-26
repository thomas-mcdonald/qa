module VotesHelper
  # vote_controls takes a post and outputs the controls seen at the side
  # of the post
  #
  # it does this by seeing which posts a user has voted on and renders the
  # appropriate partial
  def vote_controls(post, user_votes)
    user_votes ||= []
    ret = ""
    upvote = find_vote(user_votes, post, 'upvote')
    downvote = find_vote(user_votes, post, 'downvote')
    ret << select_partial(upvote, post, 'upvote')
    ret << %(<p class="vote-count">#{post.vote_count}</p>)
    ret << select_partial(downvote, post, 'downvote')
    ret.html_safe
  end

  private

  def find_vote(votes, item, vote_type)
    votes.select { |v| v.post_type == item.class.to_s && v.post_id == item.id && v.vote_type == vote_type }
  end

  def select_partial(vote, post, type)
    if !vote.empty?
      render(partial: 'votes/destroy', locals: { vote: vote.first })
    else
      render(partial: 'votes/create', locals: { post: post, vote_type: type })
    end
  end
end
