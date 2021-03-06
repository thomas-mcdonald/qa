$(document).ready ->
  $('#body').on 'ajax:beforeSend', '.add-comment', (xhr, settings) ->
    settings.setRequestHeader('accept', '*/*;q=0.5,application/json')

  # This link fetches a new comment box form
  # TODO: handle not being allowed to add new comments
  $('.post').on 'ajax:success', '.add-comment', (event, xhr, status) ->
    $(this).hide()
    $(this).parent().append(xhr.content)

  $('.post').on 'ajax:success', '#new_comment', (event, xhr, status) ->
    parent = $(this).hide().parent()
    parent.append(xhr.content)
    addQuestion = parent.find('.add-comment')
    parent.append(addQuestion.show())
    $(this).remove()
  .on 'ajax:error', '#new_comment', (event, xhr, status) ->
    json = JSON.parse(xhr.responseText)
    $(this).qaPopover(json.errors)

  $('.post').on 'click', '.comment-cancel', (e) ->
    e.preventDefault()
    $(this).parents('.comments').find('.add-comment').show()
    $(this).parents('form').remove()
