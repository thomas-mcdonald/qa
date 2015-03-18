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
    errors = status.responseJSON.errors

    if errors.body
      group = $('#answer_body').parent().parent().addClass('has-error')
      label = group.find('label')
      text = label.text()
      # append error only if not currently visible
      if text.indexOf(errors.body[0]) is -1
        label.text("#{text} - #{errors.body[0]}")
      label.flash()
