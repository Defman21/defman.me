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
        <a href='%url'>%name <span class='result-desc'>%desc</span></a>
    </span>
</div>
"""
                for item in search
                    if item.name.toLowerCase().search(regex) > -1 ||
                       item.desc.toLowerCase().search(regex) > -1 ||
                       item.tags.toLowerCase().search(regex) > -1
                        console.log "Adding #{item.name}"
                        $_tpl = $tpl
                                .replace('%url', item.url)
                                .replace('%desc', item.desc)
                                .replace '%name', item.name
                        $("#search-result").append $ $_tpl