//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_self

$ ->
  # Needs to be bound to all calls wanting a JSON response
  $(".alert-message a").bind "ajax:beforeSend", (xhr, settings) ->
    settings.setRequestHeader 'Accept', 'application/json'

  # /***************/
  $(".vote-form").live "ajax:success", (xhr, data, status) ->
    if $.isEmptyObject(data.errors)
      if data.vote.value is 1
       active = $(this).find('.upvote .vote-active').removeClass('vote-active');
       $(this).find('.upvote .vote-inactive').removeClass('vote-inactive').addClass('vote-active');
       active.addClass('vote-inactive');
      else
       active = $(this).find('.downvote .vote-active').removeClass('vote-active');
       $(this).find('.downvote .vote-inactive').removeClass('vote-inactive').addClass('vote-active');
       active.addClass('vote-inactive'); 
    else
      # $(this).popover(data.errors.voteable[0]);

  $(".alert-message a").bind "ajax:success", (xhr, data, status) ->
    $("#notification-" + data.dismiss).fadeOut 'fast', ->
      $(this).remove();

$.fn.fadeOutAndRemove = (speed) ->
  if speed == undefined
    speed = 'fast'
  return this.each ->
    $(this).fadeOut speed, ->
      $(this).remove();

