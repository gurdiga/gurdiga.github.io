---
layout: post
title: Make is still alive and kicking
date: '2016-02-04T14:56:51+02:00'
tags: [make]
categories: []
---
I do most of my work in the console, and when I work on a task, I
usually have a task-specific `Makefile`.

The other day at work, I returned in a repository where I worked before
and I wanted to check if there was any `Makefile` left from the previous
tasks in there, so I said:

```bash
$ find . -name Makefile
```

What do you think I found? — 48 matches, all but one in `node_modules`.
Wow! I never thought `make` was that popular among JavaScripters. =)

I wondered then, how many of the popular Node modules use `make`. So I
went to GitHub, and looked through their API docs, and put together a
little shell script to find that.

I picked the top 1000 most starred JavaScript repositories on GitHub,
and looked for `Makefile`, `Gruntfile.js`, `Jakefile`, and
`gulpfile.js`. Here are the numbers:

```
Jakefile — 393
Gruntfile.js — 244
Makefile — 142
gulpfile.js — 130
```

So yeah, `make` is still pretty popular. In fact, I have looked at
`make` as a build tool after I saw it used by a famous ex-JavaScripter.
I was impressed, I’m happily using it as my default since then. 8-)
