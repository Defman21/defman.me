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
          filters = []
          $("#results").empty()
          string = $(e.target).val().toLowerCase()
          if string.length <= 1
            $("#results").css 'display', 'none'
            return
          $("#results").css 'display', 'block'
          search_items = string.split " "
          words = []
          for k in search_items
            search_item = k.split ":"
            if search_item.length > 1 && search_item[1].length > 0
              words.push search_item[1]
              filters.push search_item[0]
            else if search_item[0].length > 0
              words.push search_item[0]
          $tpl ="""
<div class='result'>
  <span class='title'>
    <a href='%url'><span class='link'>%name</span> <span class='description'>%desc</span></a>
  </span>
</div>
"""
          already_found = []
          for item in results
            search = ""
            search += " #{item.tags}" if item.tags? && filters.indexOf("tag") != -1
            search += " #{item.lang}" if item.lang? && filters.indexOf("lang") != -1
            search += " #{item.type}" if item.type? && filters.indexOf("type") != -1
            search = "#{item.name} #{item.desc}" if search.length == 0
            search = search.toLowerCase()
            words.forEach (w) ->
              if search.indexOf(w) != -1 && already_found.indexOf(item.uuid) == -1
                $desc = item.desc
                $desc += " (#{item.type})" if display_type
                $_tpl = $tpl
                        .replace('%url', item.url)
                        .replace('%desc', $desc)
                        .replace '%name', item.name
                $("#results").append $ $_tpl
                already_found.push item.uuid
                found = yes
                return
          unless found
            $_tpl = $tpl
                    .replace('%url', "#")
                    .replace('%desc', "No results found")
                    .replace '%name', "No results"
            $("#results").append $ $_tpl
  do search