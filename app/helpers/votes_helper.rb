module VotesHelper
  # vote_controls takes a post and outputs the controls seen at the side
  # of the post
  #
  # it does this by seeing which posts a user has voted on and renders the
  # appropriate partial
  def vote_controls(post)
    ret = ""
    upvote = find_vote(@user_votes, post, Vote::UPVOTE)
    downvote = find_vote(@user_votes, post, Vote::DOWNVOTE)
    ret << select_partial(upvote, post, 1)
    ret << %(<p class="vote-count">#{ post.vote_count }</p>)
    ret << select_partial(downvote, post, 2)
    ret.html_safe
  end

  private

  def find_vote(votes, item, vote_type)
    votes.select { |v| v.post_type == item.class.to_s && v.post_id == item.id && v.vote_type_id == vote_type }
  end

  def select_partial(vote, post, type_id)
    if !vote.empty?
      render(partial: 'votes/destroy', locals: { vote: vote.first })
    else
      render(partial: 'votes/create', locals: { post: post, vote_type_id: type_id })
    end
  end
end