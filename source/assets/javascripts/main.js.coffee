do ($ = jQuery) ->
  $(document).ready ->
    $("a.search-link").click ->
      text = $(this).data 'search'
      $("input").val(text).trigger "keyup"
    
    $(".load-tags").click ->
      $(".hidden-tags", $(this).parent()).css 'display', 'inline-block'
      $(this).remove()