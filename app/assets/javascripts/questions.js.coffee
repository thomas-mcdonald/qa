$(document).ready ->
  $("#question_tag_list").selectize
    labelField: 'name'
    searchField: 'name'
    valueField: 'name'
    delimiter: ','
    persist: false
    create: true
    load: (query, callback) ->
      if query.length < 3
        return callback()
      $.ajax
        data:
          name: query
        error: () ->
          callback()
        type: 'GET'
        success: (response) ->
          callback(response)
        url: '/tags/search'
