(function(){!function(e,n){return e.search=function(e){var r;return r=[],n.getJSON("/json/"+e+".json",function(e){var n,a,t,s;for(s=[],n=0,t=e.length;t>n;n++)a=e[n],s.push(r.push(a));return s}).then(function(){return n("#search").keyup(function(e){var a,t,s,u,l,o,c,h;if(n("#search-result").empty(),h=n(e.target).val().toLowerCase(),!(h.length<=0)){for(o=new RegExp(h),t="<div class='result'>\n    <span class='result-name'>\n        <a href='%url'>%name</a>\n    </span>\n</div>",c=[],s=0,l=r.length;l>s;s++)u=r[s],u.name.toLowerCase().search(o)>-1?(console.log("Adding "+u.name),a=t.replace("%url",u.url).replace("%name",u.name),c.push(n("#search-result").append(n(a)))):c.push(void 0);return c}})})}}(window,jQuery)}).call(this);