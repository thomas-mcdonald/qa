$(document).ready ->
  $("#question_tag_list").selectize
    delimiter: ','
    persist: false
    create: (input) ->
        value: input
        text: input