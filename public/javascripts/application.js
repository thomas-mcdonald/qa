$(function() {
  // Needs to be bound to all calls wanting a JSON response
  $(".alert-message a").bind("ajax:beforeSend", function(xhr, settings) {
    settings.setRequestHeader('Accept', 'application/json')
  });
  ////////////
  $(".vote-form").live("ajax:success", function(xhr, data, status) {
    if($.isEmptyObject(data.errors)) {
      if(data.vote.value == 1) {
       active = $(this).find('.upvote .vote-active').removeClass('vote-active');
       $(this).find('.upvote .vote-inactive').removeClass('vote-inactive').addClass('vote-active');
       active.addClass('vote-inactive');
     } else {
       active = $(this).find('.downvote .vote-active').removeClass('vote-active');
       $(this).find('.downvote .vote-inactive').removeClass('vote-inactive').addClass('vote-active');
       active.addClass('vote-inactive');
     }
    } else {
      $(this).popover(data.errors.voteable[0]);
    }
  });
  $(".alert-message a").bind("ajax:success", function(xhr, data, status) {
    $("#notification-" + data.dismiss).fadeOut('fast', function() {
      $(this).remove();
    })
  })
});

$.fn.popover = function(string) {
  return this.each(function() {
    var popover = $('<div class="popover right"><div class="arrow"></div><div class="inner"><div class="content"><p></p></div></div></div>')
    .css({top: this.offsetTop, left: this.offsetLeft+this.scrollWidth, display: "block" })
    .click(function(e) { $(this).fadeOutAndRemove() })
    .find("p").text(string).end();
    $("body").append(popover);
    console.log(string);
  });
};

$.fn.fadeOutAndRemove = function(speed) {
  if(speed == undefined) {
    speed = 'fast'
  }
  return this.each(function() {
    $(this).fadeOut(speed, function() {
      $(this).remove();
    });
  });
};
