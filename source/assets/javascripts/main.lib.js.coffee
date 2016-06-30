do ($ = jQuery) ->
  $(document).ready ->
    opened = no
    if localStorage.getItem('donttrackme') != null
      $(".dont-track-me").remove()
    $('.button-preview').on 'click', ->
      if not opened
        $('.preview').removeClass('close').addClass 'open'
        opened = yes
        $(this).removeClass('open').addClass 'close'
      else
        $('.preview').removeClass('open').addClass 'close'
        opened = no
        $(this).removeClass('close').addClass 'open'
    
    $('.dont-track-me .checkbox').on 'click', ->
      $(@).addClass "checked"
      localStorage.setItem('donttrackme', true)
      (i=$(@).parent().find(".description")).html(i.html()+" / Reload to apply changes")