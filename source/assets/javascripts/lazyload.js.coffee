do ->
  DisqusCommentsLoaded = no
  elem = document.getElementsByClassName('links')[0]
  _isScrolledIntoView = (e) ->
    r = e.getBoundingClientRect()
    et = r.top
    eb = r.bottom
    (et > 0) && (eb <= window.innerHeight)
  
  _loadComments = ->
    if _isScrolledIntoView(elem) and not DisqusCommentsLoaded
      DisqusCommentsLoaded = yes
      if loadDisqusComments?
        do loadDisqusComments
  
  document.addEventListener 'DOMContentLoaded', ->
    _loadComments()
  
  document.onscroll = ->
    _loadComments()