$(document).ready ->
  $(".vote-form").on 'ajax:success', (event, xhr, status) ->
    if xhr.vote_type_id == 1
      $(this).find('.upvote').addClass('vote-active')
    else if xhr.vote_type_id == 2
      $(this).find('.downvote').addClass('vote-active')

  $(".vote-form").on 'ajax:error', (event, xhr, status) ->
    # TODO: handle error on vote submit
    console.log event
    console.log xhr
    console.log status