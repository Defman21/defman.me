do ($ = jQuery) ->
  activeTab = (tab_id = 1) ->
    $iframe = "
<iframe width='100%' height='100%' src='https://www.youtube.com/embed/%url?rel=0&amp;controls=0&amp;showinfo=0' frameborder='0' allowfullscreen></iframe>
"
    $(".frame").each ->
      $tab_id = tab_id
      if $(@).data('frame-id') == ($tab_id || 1)
        $(@).siblings().removeClass 'active'
        $(@).addClass 'active'
        unless $(@).data 'loaded'
          console.log "Loading #{$(@).data 'video-id'}"
          $(".content", @).html $iframe.replace '%url', $(@).data 'video-id'
          $(@).data 'loaded', true
  
  do activeTab
  
  $(document).ready ->
    $(".tab").on 'click', ->
      $tab_id = $(@).data 'tab-id'
      $(@).siblings().removeClass 'active'
      $(@).addClass 'active'
      activeTab $tab_id