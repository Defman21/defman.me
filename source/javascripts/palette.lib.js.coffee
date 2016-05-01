do ($ = jQuery) ->
  on_hover_in = ->
    $id = $(@).attr("id").split("-")[1]
    console.log($id)
    $(".base-#{$id}").addClass "hover"

  on_hover_out = ->
    $id = $(@).attr("id").split("-")[1]
    console.log($id)
    $(".base-#{$id}").removeClass "hover"

  $(".color").hover on_hover_in, on_hover_out
