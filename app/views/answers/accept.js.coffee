root = $("#answer-<%= @answer.id %>-accept")
active = root.find('.vote-active').removeClass('vote-active');
root.find('.vote-inactive').removeClass('vote-inactive').addClass('vote-active');
active.addClass('vote-inactive');