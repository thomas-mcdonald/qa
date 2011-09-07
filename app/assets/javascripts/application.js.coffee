//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .

$ ->
  /* Needs to be bound to all calls wanting a JSON response */
  $(".alert-message a").bind "ajax:beforeSend", (xhr, settings) ->
    settings.setRequestHeader 'Accept', 'application/json'

  /***************/
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
      $(this).popover(data.errors.voteable[0]);

  $(".alert-message a").bind "ajax:success", (xhr, data, status) ->
    $("#notification-" + data.dismiss).fadeOut 'fast', ->
      $(this).remove();

$.fn.popover = (string) -> 
  return this.each ->
    popover = $('<div class="popover right"><div class="arrow"></div><div class="inner"><div class="content"><p></p></div></div></div>')
      .css({top: this.offsetTop, left: this.offsetLeft+this.scrollWidth, display: "block" })
      .click ->
        $(this).fadeOutAndRemove();
      .find("p").text(string).end();
    $("body").append(popover);

$.fn.fadeOutAndRemove = (speed) ->
  if speed == undefined
    speed = 'fast'
  return this.each ->
    $(this).fadeOut speed, ->
      $(this).remove();

