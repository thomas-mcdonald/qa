# code for accepting an answer
$(document).ready ->
  $('.controls').on 'ajax:success', '.accept-form, .unaccept-form', (event, xhr, status) ->
    $(this).parent().replaceWith(xhr.content)

  # submitting answer inline
  $('#body').on 'ajax:beforeSend', '#new_answer', (xhr, settings) ->
    # required to return a json response. maybe appropriate for all req?
    # TODO: check if this could be extracted. certainly could be fn call
    settings.setRequestHeader('accept', '*/*;q=0.5,application/json')
  .on 'ajax:success', '#new_answer', (event, xhr, status) ->
    # TODO: get a fresh form from the controllers
    $(xhr.content).hide().appendTo('.answers').fadeIn()
  .on 'ajax:error', '#new_answer', (xhr, status, error) ->
    console.log xhr
    console.log status
    console.log error
