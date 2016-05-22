do (w = window, $ = jQuery) ->
    w.search = (json) ->
        search = []
        $.getJSON("/json/#{json}.json", (result) ->
            for item in result
                search.push item
        ).then ->
            $("#search").keyup (e) ->
                $("#search-result").empty()
                string = $(e.target).val().toLowerCase()
                return if string.length <= 0
                regex = new RegExp string
                $tpl ="""
<div class='result'>
    <span class='result-name'>
        <a href='%url'>%name</a>
    </span>
</div>
"""
                for item in search
                    if item.name.toLowerCase().search(regex) > -1
                        console.log "Adding #{item.name}"
                        $_tpl = $tpl.replace('%url', item.url).replace '%name', item.name
                        $("#search-result").append $ $_tpl