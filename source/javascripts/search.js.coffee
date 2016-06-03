do (w = window, $ = jQuery) ->
    w.search = (json, display_type = false) ->
        search = []
        $.getJSON("/json/#{json}.json", (result) ->
            for item in result
                search.push item
        ).then ->
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
                for item in search
                    if item.name.search(regex) > -1 || 
                       item.desc.search(regex) > -1 || 
                       (item.tags? && item.tags.search(regex) > -1) ||
                       (item.lang? && item.lang.search(regex) > -1)
                        $name = item.name
                        $name += " (#{item.type if display_type})"
                        $_tpl = $tpl
                                .replace('%url', item.url)
                                .replace('%desc', item.desc)
                                .replace '%name', $name
                        $("#search-result").append $ $_tpl