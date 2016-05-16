do ($ = jQuery) ->
  is_scrolling = off

  on_hover_in = ->
    $$ = $(@)
    hash = $$[0].hash[1..]
    $("##{hash} .title").addClass "hash-#{hash}"

  on_hover_out = ->
    return if is_scrolling
    $$ = $(@)
    hash = $$[0].hash[1..]
    $("##{hash} .title").removeClass "hash-#{hash}"

  $("header a.hash-href").hover on_hover_in, on_hover_out

  $("header a.hash-href").click (e) ->
    is_scrolling = on
    $$ = $(@)
    e.preventDefault()
    hash = $$[0].hash[1..]
    $("##{hash} .title").addClass "hash-#{hash}"
    hide = ->
      $("##{hash} .title").removeClass "hash-#{hash}"
    setTimeout hide, 1000
    
    console.log "Scroll to ##{hash}"
    
    $("body").scrollTo "##{hash}", {
      'duration': "fast",
      'onAfter': ->
        location.hash = $$.attr("href")[1..]
        console.log "Ended scrolling to ##{hash}"
        setTimeout ->
          is_scrolling = off
        , 100
    }

  $("main a").each ->
    $(@).attr "target", "_blank" if $(@)[0].href[0..3] == "http"
