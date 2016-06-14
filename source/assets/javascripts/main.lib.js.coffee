do ($ = jQuery) ->
  $(document).ready ->
    opened = no
    $('.button-preview').on 'click', ->
      if not opened
        $('.preview').removeClass('close').addClass 'open'
        opened = yes
        $(this).removeClass('open').addClass 'close'
      else
        $('.preview').removeClass('open').addClass 'close'
        opened = no
        $(this).removeClass('close').addClass 'open'