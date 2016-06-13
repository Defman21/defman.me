do ($ = jQuery) ->
  $(document).ready ->
    opened = no
    $('.open-preview').on 'click', ->
      if not opened
        $('.preview').removeClass('close').addClass 'open'
        opened = yes
        $(this).html "Close preview"
      else
        $('.preview').removeClass('open').addClass 'close'
        opened = no
        $(this).html "Open preview"