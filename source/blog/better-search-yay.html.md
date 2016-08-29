---
title: Better search!
description: Today I'm introducing an update to the search engine on my web-site. Now you can specify tags, language and type of an item to get what you want.
date: 201608292225
id: 201608292225-better-search-yay
tags: defman.me search javascript
---

Today I've updated the search input a bit: now you can see a placeholder that
says you can use some prefixes to do an advanced search over my web-site.

I'd want to describe what it can:

* The search should be much faster now - it won't search in metadata of items
anymore. Title and description of an item is used for basic search.
* Now you can use prefixes to search in metadata:
 * `tag:<tag>` will search for a tag.
 * `lang:<lang>` will search for a language (related to projects)
 * `type:<type>` will search for a type of an item (I'm using it on 404 page)

You can combine them as well. But there's a thing that I want to mention:

For example, if you'll search for `tag:ruby tag:git`, it won't filter it as
«Search for articles with `ruby` tag, then search for `git` tag in them». It will
«search for `ruby` tag and `git` tag, then combine results».