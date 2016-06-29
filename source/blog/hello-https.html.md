---
title: Hello HTTPS
description: Finally defman.me is now available at https://defman.me (no http anymore)
date: 201606290925
id: 201606290925-hello-https
tags: https security letsencrypt
---
Today I've decided to provide some security on my web-site. I know it's static
and so, but there are comments which makes browser thinks there are some
inputs that are being sent to the server over insecure protocol.

Well, this is not that hard as it could be, buts it's a bit expensive:
I had to buy a VPS for that to proxy everything from https://defman.me to
https://defman21.github.io (there's some CNAME magic and I don't want to dig in
it, it just works). But I really wanted HTTPS on my web-site so I think it's
worth it.