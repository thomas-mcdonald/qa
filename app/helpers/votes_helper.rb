module VotesHelper
  def vote_controls(post)
    ret = ""
    upvote = find_vote(@user_votes, post, Vote::UPVOTE)
    downvote = find_vote(@user_votes, post, Vote::DOWNVOTE)
    if !upvote.empty?
      # current upvote
      ret << render(partial: 'votes/destroy', locals: { vote: upvote.first, vote_type_id: 1 })
    else
      # not yet upvoted
      ret << render(partial: 'votes/create', locals: { post: post, vote_type_id: 1 })
    end
    ret << %(<p class="vote-count">#{ post.vote_count }</p>)
    if !downvote.empty?
      ret << render(partial: 'votes/destroy', locals: { vote: downvote.first, vote_type_id: 2 })
    else
      ret << render(partial: 'votes/create', locals: { post: post, vote_type_id: 2 })
    end
    ret.html_safe
  end

  def find_vote(votes, item, vote_type)
    votes.select { |v| v.post_type == item.class.to_s && v.post_id == item.id && v.vote_type_id == vote_type }
  end
end