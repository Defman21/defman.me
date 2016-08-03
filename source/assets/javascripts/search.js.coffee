do (w = window, $ = jQuery) ->
  search = () ->
    json = search_config.type
    display_type = search_config.show_type
    console.log search_config
    results = []
    $.getJSON("/json/#{json}.json", (result) ->
      for item in result
        results.push item
      ).then ->
        $("#search input").focus()
        $("#search input").keyup (e) ->
          found = no
          $("#results").empty()
          string = $(e.target).val().toLowerCase()
          if string.length <= 0
            $("#results").css 'display', 'none'
            return
          $("#results").css 'display', 'block'
          regex = new RegExp string, "i"
          $tpl ="""
<div class='result'>
  <span class='title'>
    <a href='%url'><span class='link'>%name</span> <span class='description'>%desc</span></a>
  </span>
</div>
"""
          for item in results
            search = "#{item.name} #{item.desc}"
            search += " #{item.tags}" if item.tags?
            search += " #{item.lang}" if item.lang?
            search += " #{item.type}" if item.type?
            search = search.toLowerCase()
            if search.search(regex) > -1
                $desc = item.desc
                $desc += " (#{item.type})" if display_type
                $_tpl = $tpl
                        .replace('%url', item.url)
                        .replace('%desc', $desc)
                        .replace '%name', item.name
                found = yes
                $("#results").append $ $_tpl
          unless found
            $_tpl = $tpl
                    .replace('%url', "#")
                    .replace('%desc', "No results found")
                    .replace '%name', "No results"
            $("#results").append $ $_tpl
  do search