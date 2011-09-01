$(function() {
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
  $(".vote-form").live("ajax:error", function(xhr, status, data) {
    console.log(data);
  });
});
