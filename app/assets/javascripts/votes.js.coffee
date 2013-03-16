$(document).ready ->
  $(".vote-controls").on 'ajax:success', '.vote-form', (event, xhr, status) ->
    $(this).parent().find('.vote-count').html(xhr.count)
    $(this).replaceWith(xhr.content)

  $(".vote-form").on 'ajax:error', (event, xhr, status) ->
    $t = $(this)
    json = $.parseJSON(xhr.responseText)
    $t.popover
      content: json.errors
      placement: 'bottom'
      trigger: 'manual'
    $t.popover('show')
    $(document).one 'click', ->
      $t.popover('destroy')