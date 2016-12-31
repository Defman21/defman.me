do (w = window, $ = jQuery) ->
  $(document).keyup (e) ->
    if e.keyCode == 27
      $("#results").empty().css 'display', 'none'
  
  $(document).click (e) ->
    $("#results").css 'display', 'none'
    
  $(document).on 'click', '.result, #search input', (e) ->
    e.stopPropagation()
  
  $("#results").css 'display', 'none'
  
  (() ->
    @search.setData = (data) -> @__data = data
    
    @search.createSearch = (string) ->
      new Promise (res, rej) =>
        @__searchData =
          keywords: []
          filters:
            tag: []
            lang: []
            type: []
        for word in string.split " "
          word = word.split ":"
          if word.length > 1 && word[1].length > 0
            @__searchData.filters[word[0]].push word[1]
          else if word[0].length > 0
            @__searchData.keywords.push word[0]
        res()
    
    @search.__findInObject = (data, object, original) ->
      new Promise (res, rej) ->
        if data.keywords.length
          index = object.name.indexOf(data.keywords.join " ")
          if index != -1
            original.index = index
            return res original
        if data.filters.tag.length
          for tag in data.filters.tag
            if object.tags.indexOf(tag) != -1
              return res original
        if data.filters.lang.length
          for lang in data.filters.lang
            if object.lang == lang
              return res original
        if data.filters.type.length
          for type in data.filters.type
            if object.type == type
              return res original
        rej "Not found: #{JSON.stringify data} in #{JSON.stringify object}"
    
    @search.filter = () ->
      @__results = []
      __promises = []
      
      for item in @__data
        _object =
          name: "#{item.name} #{item.desc}".toLowerCase()
          tags: item.tags
          lang: item.lang
          type: item.type
          index: 9000
        __promises.push @__findInObject(@__searchData, _object, item).then (item) =>
          @__results.push item
        , (err) -> null
      
      Promise.all(__promises).then () =>
        @render()
    
    @search.render = () ->
      $render = ""
      $tpl = """
<div class='result'>
  <span class='title'>
    <a href='%url'><span class='link'>%name</span> <span class='description'>%desc</span></a>
  </span>
</div>
"""
      $("#results").empty()
      $("#results").css 'display', 'block'
      if @__results.length
        @__results = @__results.sort (a, b) -> a.index - b.index
        for item in @__results
          $render += $tpl
                    .replace('%url', item.url)
                    .replace('%desc', item.desc)
                    .replace '%name', item.name
        $("#results").html $render
      else
         $render = $tpl
                  .replace('%url', "#")
                  .replace('%desc', "No results found")
                  .replace '%name', "No results"
        $("#results").html $render
  ).apply w
  
  search = () ->
    json = search_config.type
    display_type = search_config.show_type
    $.getJSON("/json/#{json}.json", (data) -> w.search.setData data).then ->
      $("#search input").focus (e) ->
          string = $(e.target).val().toLowerCase()
          if string.length == 0
            $("#results").css 'display', 'none'
          else if string.length >= 2
            w.search.createSearch(string).then () -> w.search.filter()
        
      $("#search input").focus()
      
      $("#search input").keyup (e) ->
        string = $(e.target).val().toLowerCase()
        if string.length == 0
          $("#results").css 'display', 'none'
        else if string.length >= 2
          w.search.createSearch(string).then () -> w.search.filter()

  do search