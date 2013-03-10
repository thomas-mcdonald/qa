module VotesHelper
  def vote_controls(vote_item)
    %Q[
      <form action="/votes" method="post" data-remote="true" class="vote-form" id="#{vote_item.class.name.downcase}-#{vote_item.id}">
        #{ hidden_field_tag "vote[post_id]", vote_item.id }
        #{ hidden_field_tag "vote[post_type]", vote_item.class }
        <button type="submit" name="vote[vote_type_id]" value="1" class="arrow upvote">
          <i class="icon-chevron-up #{active_class(vote_item, 1)}"></i>
        </button>
        <p class="vote-count">#{ vote_item.vote_count }</p>
        <button type="submit" name="vote[vote_type_id]" value="2" class="arrow downvote">
          <i class="icon-chevron-down #{active_class(vote_item, 2)}"></i>
        </button>
      </form>
    ].html_safe
  end

  def active_class(vote_item, vote_type_id)
    type = "upvote" if vote_type_id == 1
    type = "downvote" if vote_type_id == 2
    if logged_in?
      flag = vote_item.votes.select { |v| v.user_id == current_user.id && v.vote_type_id == vote_type_id }.length > 0
    else
      flag = false
    end
    flag ? "vote-active #{type}" : "vote-inactive #{type}"
  end
end