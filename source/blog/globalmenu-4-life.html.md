---
title: Add global menu for Komodo X in Unity
description: Missing global menu for Komodo X in Ubuntu Unity? This article will help you bring it back!
date: 201609010010
id: 201609010010-globalmenu-4-life
tags: globalmenu komodo
---

Unity globalmenu will back in [Komodo 11][1].

For now you can do this:

1. Download [global menu patch][2]
2. Extract:

```
noarch/mozilla/chrome/toolkit/content/global/bindings/popup.xml to Komodo/lib/mozilla/chrome/toolkit/content/global/bindings/
noarch/mozilla/chrome/toolkit/content/global/xul.css to Komodo/lib/mozilla/chrome/toolkit/content/global/
noarch/mozilla/greprefs.js to Komodo/lib/mozilla/
x86(_64)/mozilla/libxul.so to Komodo/lib/mozilla/
```

[1]: https://github.com/Komodo/KomodoEdit/pull/868
[2]: https://launchpad.net/komodo-edit/10.0/10.0.1+17276/+download/komodo-unity-menubar-10.0.1.zip