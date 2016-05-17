do ($ = jQuery) ->
  $("main a").each ->
    $(@).attr "target", "_blank" if $(@)[0].href[0..3] == "http"
