module VotesHelper
  def vote_controls(vote_item)
    %Q[
      <form action="/votes" method="post" data-remote="true" class="vote-form" id="#{vote_item.class.name.downcase}-#{vote_item.id}">
        #{ hidden_field_tag "vote[voteable_id]", vote_item.id }
        #{ hidden_field_tag "vote[voteable_type]", vote_item.class }
        <button type="submit" name="value" value="1" class="arrow upvote">
          #{ image_tag 'vote-up-off.png', :class => active_class(vote_item, 1, false) }
          #{ image_tag 'vote-up-on.png', :class => active_class(vote_item, 1, true) }
        </button>
        <p class="vote-count">#{ vote_average(vote_item) }</p>
        <button type="submit" name="value" value="-1" class="arrow downvote">
          #{ image_tag 'vote-down-off.png', :class => active_class(vote_item, -1, false) }
          #{ image_tag 'vote-down-on.png', :class => active_class(vote_item, -1, true) }
        </button>

      </form>
    ].html_safe
  end
  
  def vote_average(vote_item)
    i = 0
    vote_item.votes.each do |vote|
      i += vote.value
    end
    i
  end

  def active_class(vote_item, value, want)
    type = "upvote" if value == 1
    type = "downvote" if value == -1
    if logged_in?
      flag = !current_user.votes.where(:voteable_id => vote_item.id, :voteable_type => vote_item.class, :value => value).first.blank?
    else
      flag = false
    end
    flag == want ? "vote-active #{type}" : "vote-inactive #{type}"
  end
end
