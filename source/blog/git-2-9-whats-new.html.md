---
title: "Git 2.9: What's new?"
description: Git 2.9 has been released. There are some cool features that I want to show.
date: 201606141727
id: 201606141727-git-2-9-whats-new
tags: git
---

As you may know, git 2.9 has been released yesterday. I've switched from 2.7
to this version because there are some interesting features.

# Faster submodules

Git 2.8 introduced a new option called `--jobs` that allows to do specific
tasks in parallel (`git fetch` in 2.8). In 2.9, this option has been added
to `git clone --recurse-submodules` and `git submodule update`.
Now you can use this to clone or update submodules much faster. You can set
`submodule.fetchJobs` to always process submodules in parallel.

# Better diffs

In git 2.9, it's diff engine learned a new heuristic. You can read about it
[there][1], to enable it you can pass `--compaction-heuristic` option to git or
set `diff.compactionHeuristic` to `1`.

# Testing all the commits with rebase -x

`rebase` is a powerful tool for editing commits (squashing, removing, etc.).
Now it supports `-x` option which will execute specific command at each commit.

For example, you have 5 commits. If you run `git rebase -x 'my test command'`,
git will execute it for each commit and if it will fail (exit code != 0), git
will suggest you to fix the problem, commit it (`-a --amend`) and continue
the rebase.

You can see the release notes [here][2]

Happy hacking!

[1]: //github.com/blog/2188-git-2-9-has-been-released
[2]: //github.com/git/git/blob/v2.9.0/Documentation/RelNotes/2.9.0.txt