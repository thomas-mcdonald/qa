$(function() {
  // Needs to be bound to all calls wanting a JSON response
  $(".alert-message a").bind("ajax:beforeSend", function(xhr, settings) {
    settings.setRequestHeader('Accept', 'application/json')
  });
  ////////////
  $(".vote-form").live("ajax:success", function(xhr, data, status) {
    if(data.vote.value == 1) {
      active = $(this).find('.upvote .vote-active').removeClass('vote-active');
      $(this).find('.upvote .vote-inactive').removeClass('vote-inactive').addClass('vote-active');
      active.addClass('vote-inactive');
    } else {
      active = $(this).find('.downvote .vote-active').removeClass('vote-active');
      $(this).find('.downvote .vote-inactive').removeClass('vote-inactive').addClass('vote-active');
      active.addClass('vote-inactive');
    }
  });
  $(".alert-message a").bind("ajax:success", function(xhr, data, status) {
    $("#notification-" + data.dismiss).fadeOut('fast', function() {
      $(this).remove();
    })
  })
});
