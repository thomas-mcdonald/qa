$(document).ready ->
  $(".vote-controls").on 'ajax:success', '.vote-form', (event, xhr, status) ->
    $(this).parent().find('.vote-count').html(xhr.count)
    $(this).replaceWith(xhr.content)

  $(".vote-form").on 'ajax:error', (event, xhr, status) ->
    json = $.parseJSON(xhr.responseText)
    $(this).qaPopover(json.errors)
