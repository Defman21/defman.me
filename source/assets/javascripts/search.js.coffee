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
        $("#search").focus()
        $("#search").keyup (e) ->
          $("#search-result").empty()
          string = $(e.target).val().toLowerCase()
          return if string.length <= 0
          regex = new RegExp string, "i"
          $tpl ="""
<div class='result'>
  <span class='result-name'>
    <a href='%url'><span class='result-link'>%name</span> <span class='result-desc'>%desc</span></a>
  </span>
</div>
"""
          for item in results
            if item.name.search(regex) > -1 || 
              item.desc.search(regex) > -1 || 
              (item.tags? && item.tags.search(regex) > -1) ||
              (item.lang? && item.lang.search(regex) > -1) ||
              (item.type? && item.type.search(regex) > -1)
                $desc = item.name
                $desc += " (#{item.type})" if display_type
                $_tpl = $tpl
                        .replace('%url', item.url)
                        .replace('%desc', $desc)
                        .replace '%name', item.name
                $("#search-result").append $ $_tpl
  do search