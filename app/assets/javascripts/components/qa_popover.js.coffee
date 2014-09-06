$.fn.qaPopover = (content) ->
  this.each (e) ->
    $t = $(this)
    $t.popover
      content: content
      placement: 'bottom'
      trigger: 'manual'
    .popover('show')
    $(document).one 'click', ->
      $t.popover('destroy')
