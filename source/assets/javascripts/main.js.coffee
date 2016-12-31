do ($ = jQuery) ->
  $(document).ready ->
    $("a.search-link").click ->
      text = $(this).data 'search'
      $target = $("#search input")
      $target.val(text)
      setTimeout ->
        $target.focus()
      , 0
    
    $(".load-tags").click ->
      $(".hidden-tags", $(this).parent()).css 'display', 'inline-block'
      $(this).remove()
    
    $("#load_comments").click ->
      do loadDisqusComments