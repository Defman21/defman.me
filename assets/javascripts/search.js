(function(){!function(e,n){var s;return(s=function(){var e,t,l;return t=search_config.type,e=search_config.show_type,console.log(search_config),l=[],n.getJSON("/json/"+t+".json",function(e){var n,s,t,r;for(r=[],n=0,t=e.length;t>n;n++)s=e[n],r.push(l.push(s));return r}).then(function(){return n("#search input").focus(),n("#search input").keyup(function(t){var r,a,u,c,p,i,o,h,d,f,g,y,v,m,O;if(p=!1,c=[],n("#results").empty(),m=n(t.target).val().toLowerCase(),m.length<=0)return void n("#results").css("display","none");for(n("#results").css("display","block"),v=m.split(" "),O=[],i=0,f=v.length;f>i;i++)d=v[i],y=d.split(":"),y.length>1&&y[1].length>0?(O.push(y[1]),c.push(y[0])):y[0].length>0&&O.push(y[0]);for(a="<div class='result'>\n  <span class='title'>\n    <a href='%url'><span class='link'>%name</span> <span class='description'>%desc</span></a>\n  </span>\n</div>",u=[],h=0,g=l.length;g>h;h++)o=l[h],s="",null!=o.tags&&-1!==c.indexOf("tag")&&(s+=" "+o.tags),null!=o.lang&&-1!==c.indexOf("lang")&&(s+=" "+o.lang),null!=o.type&&-1!==c.indexOf("type")&&(s+=" "+o.type),0===s.length&&(s=o.name+" "+o.desc),s=s.toLowerCase(),O.forEach(function(t){var l,r;-1!==s.indexOf(t)&&-1===u.indexOf(o.uuid)&&(r=o.desc,e&&(r+=" ("+o.type+")"),l=a.replace("%url",o.url).replace("%desc",r).replace("%name",o.name),n("#results").append(n(l)),u.push(o.uuid),p=!0)});return p?void 0:(r=a.replace("%url","#").replace("%desc","No results found").replace("%name","No results"),n("#results").append(n(r)))})})})()}(window,jQuery)}).call(this);