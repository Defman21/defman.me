(function(){!function(t){var a;return a=function(a){var i;return null==a&&(a=1),i="<iframe width='100%' height='100%' src='https://www.youtube.com/embed/%url?rel=0&amp;controls=0&amp;showinfo=0' frameborder='0' allowfullscreen></iframe>",t(".frame").each(function(){var e;if(e=a,t(this).data("frame-id")===(e||1)&&(t(this).siblings().removeClass("active"),t(this).addClass("active"),!t(this).data("loaded")))return console.log("Loading "+t(this).data("video-id")),t(".content",this).html(i.replace("%url",t(this).data("video-id"))),t(this).data("loaded",!0)})},a(),t(document).ready(function(){return t(".tab").on("click",function(){var i;return i=t(this).data("tab-id"),t(this).siblings().removeClass("active"),t(this).addClass("active"),a(i)})})}(jQuery)}).call(this);