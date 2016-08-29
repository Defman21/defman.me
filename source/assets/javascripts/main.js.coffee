do ($ = jQuery) ->
  $(document).ready ->
    $("a.search-link").click ->
      text = $(this).data 'search'
      $("input").val(text).trigger "keyup"