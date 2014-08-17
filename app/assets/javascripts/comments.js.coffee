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
    $t = $(this)
    json = JSON.parse(xhr.responseText)
    $t.popover
      content: json.errors
      placement: 'bottom'
      trigger: 'manual'
    .popover('show')
    $(document).one 'click', ->
      $t.popover('destroy')