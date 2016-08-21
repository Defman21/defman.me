do ($ = jQuery) ->
  $(document).ready ->
    $("a.tag").click ->
      text = $(this).html()
      $("input").val(text).trigger "keyup"