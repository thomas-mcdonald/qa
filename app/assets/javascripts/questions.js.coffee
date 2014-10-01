$(document).ready ->
  # Would be nice to not have to remove this class here but it's easy enough
  $("#question_tag_list").removeClass('form-control').selectize
    delimiter: ','
    persist: false
    create: (input) ->
        value: input
        text: input