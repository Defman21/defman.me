---
title: How to make git diff looks better
description: Wondering How to make git diff looks a bit better? This article can help you with it!
date: 201606141833
id: 201606141833-how-to-make-git-diff-looks-better
tags: git
---
By default, `git diff` looks not that good as it could be. If you use GitHub,
you can see how good it can looks. We'll try to achieve something similar to
Github's diff.

# Diff-highlight

`diff-highlight` is a contributed tool which shows better diff by comparing
strings by character.
So, if your diff looks like:

```diff
- hello, world
+ hello, people
```

It will highlight `world` as old (red background) and `people` as new
(green background).

[You can grab the script here][1] and install it by placing it to `/usr/bin/`

# Diff-so-fancy

This project makes diff looks **much** better!

![screen][2]

On the left side, it's the default diff. On the right side, it's the diff
with `diff-so-fancy`.

You can install it by `npm install -g diff-so-fancy`. This will install `diff-
highlight` as well.

For more info, see the [github project][3].

I'm using Forest scheme for terminal, so the config suggested by diff-so-fancy
looks not that good. I've picked some nice colors, so if you're using Forest
as well, enter these commands instead of the suggested:

```sh
git config --global color.diff-highlight.oldNormal "red" 
git config --global color.diff-highlight.oldHighlight "red 217"
git config --global color.diff-highlight.newNormal "green"
git config --global color.diff-highlight.newHighlight "green 157"
```

![git diff forest](git-diff-forest.png)

Happy diffing! :D

[1]: //github.com/git/git/blob/master/contrib/diff-highlight/diff-highlight
[2]: https://cloud.githubusercontent.com/assets/39191/13622719/7cc7c54c-e555-11e5-86c4-7045d91af041.png
[3]: //github.com/so-fancy/diff-so-fancy
