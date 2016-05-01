do ($ = jQuery) ->
  is_scrolling = off

  on_hover_in = ->
    $$ = $(@)
    hash = $$[0].hash[1..]
    $("##{hash}").addClass "hash-#{hash}"

  on_hover_out = ->
    console.log is_scrolling
    return if is_scrolling
    $$ = $(@)
    hash = $$[0].hash[1..]
    $("##{hash}").removeClass "hash-#{hash}"

  $("header a").hover on_hover_in, on_hover_out

  $("header a[id^=h]").click (e) ->
    is_scrolling = on
    $$ = $(@)
    e.preventDefault()
    hash = $$[0].hash[1..]
    $("##{hash}").addClass "hash-#{hash}"
    hide = ->
      $("##{hash}").removeClass "hash-#{hash}"
    setTimeout hide, 1000
    
    $("body").scrollTo "##{hash}", {
      'duration': "fast",
      'onAfter': ->
        location.hash = $$.attr "href"
        setTimeout ->
          is_scrolling = off
        , 100
    }

  $("main a").each ->
    $(@).attr "target", "_blank" if $(@)[0].href[0..3] == "http"
