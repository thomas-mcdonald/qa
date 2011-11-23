$ ->
  $('#notification-toggle').twipsy
    placement: 'below'
  .click (e) ->
    e.preventDefault()
    $("body").css(
      marginTop: 40
    )
    $("#notification-centre").slideDown()

  $(".notification a").bind "ajax:beforeSend", (xhr, settings) ->
    settings.setRequestHeader 'Accept', 'application/json'
  .bind "ajax:success", (xhr, data, status) ->
    $("#notification-" + data.dismiss).addClass('dismissed').find('a.close').remove()
