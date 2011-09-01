module VotesHelper
  def vote_controls(vote_item)
    %Q[
      <form action="/votes" method="post" data-remote="true" class="vote-form" id="#{vote_item.class.name.downcase}-#{vote_item.id}">
        #{ hidden_field_tag "vote[voteable_id]", vote_item.id }
        #{ hidden_field_tag "vote[voteable_type]", vote_item.class }
        <button type="submit" name="value" value="1" class="arrow upvote">
          #{ image_tag 'vote-up-off.png', :class => "vote-active" }
          #{ image_tag 'vote-up-on.png', :class => "vote-inactive" }
        </button>
        #{ vote_average(vote_item) }
        <button type="submit" name="value" value="-1" class="arrow downvote">
          #{ image_tag 'vote-down-off.png', :class => "vote-active" }
          #{ image_tag 'vote-down-on.png', :class => "vote-inactive" }
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
end
