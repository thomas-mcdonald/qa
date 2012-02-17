$ ->
  $('#notification-toggle').tooltip
    placement: 'bottom'
  .click (e) ->
    e.preventDefault()
    if $("#notification-centre").css('display') == "block"
      $("#notification-centre").slideUp()
    else
      $("#notification-centre").slideDown()

  $(".notification a").bind "ajax:beforeSend", (xhr, settings) ->
    settings.setRequestHeader 'Accept', 'application/json'
  .bind "ajax:success", (xhr, data, status) ->
    $("#notification-" + data.dismiss).addClass('dismissed').find('a.close').remove()
