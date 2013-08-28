$(document).ready ->
  $('.controls').on 'ajax:success', '.accept-form', (event, xhr, status) ->
    $(this).parent().replaceWith(xhr.content)

  # TODO: handle error... needs tidying up with controller though.