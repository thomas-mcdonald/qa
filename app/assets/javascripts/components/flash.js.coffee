$.fn.flash = (content) ->
  this.each (e) ->
    el = $(this);
    $("<div/>")
      .width(el.outerWidth())
      .height(el.outerHeight())
      .css(
        "position": "absolute"
        "left": el.offset().left
        "top": el.offset().top
        "background-color": "#ffff99"
        "opacity": ".7"
        "z-index": "9999999"
      ).appendTo('body').fadeOut(500).queue ->
        $(this).remove()