$(document).ready ->
  $('#body').on 'ajax:beforeSend', '.add-comment', (xhr, settings) ->
    settings.setRequestHeader('accept', '*/*;q=0.5,application/json')

  # This link fetches a new comment box form
  $('.post').on 'ajax:success', '.add-comment', (event, xhr, status) ->
    $(this).hide();
    $(this).parent().prepend(xhr.content)
