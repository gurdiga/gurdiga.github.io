---
layout: post
title: My Git trail map
date: '2015-07-25T20:34:53+03:00'
---
In my last article I said that I have started a little study by
following [thoughtbot’s trail maps](https://github.com/thoughtbot/trail-map).
After Heroku, I’ve picked Git, and today I will write about the things
I’ve learned from it.

My favorite part was
[the “Learn Git Branching” interactive tutorial](http://learngitbranching.js.org/).
Its gorgeous animated visualizations help a lot in understanding the
mechanics of rebase, merge, branch reset, and cherry-pick. It also has
practical exercises at the end of every lesson.

I thought I knew Git good enough to use it, how could I not — I’m using
it for the last few years, right? It turned out that I had some blind
spots which I’m glad this tutorial covered. :) Here they are:

* what is `HEAD` and detached `HEAD` — this is something that I see a
	lot while working with Git, and somehow I accepted it lie around
	without actually understanding it. So although it’s a pretty simple
	concept — the revision where you’re currently on. It’s somewhat
	similar to the “cursor” concept in databases. The `HEAD` is said to be
	_detached_ when it points to something that is not a branch, and when
	it is, you cannot commit; you can only commit onto a branch. It may be
	insignificant, and I would have probably been able to happily live
	without understanding it, but it feels a little better now when I know
	what it is. :)
* `git branch -f <branch_name> <revision>` — resets the head of the given
	branch to the given revision. Now that I’m typing it I realize that it
	does what `git reset --hard <revision>` when you’re on
	`<branch_name>`. Not a big deal, but I like to have found about it.
* the difference between `~` and `^` — this is something that I was
	wondering about, but because I could work without it, I never went on
	to find out about. Here is the formula I wrote in my notes: `HEAD~ ==
	HEAD~1 == HEAD^1 == HEAD^`. Other than that: `^<revision>` reads as
	“parent of `<revision>`”, and you can use it three times to mean
	“parent of parent of parent”, but it’s easier to just say ~3 instead,
	although it may mean something different when `<revision>` is a merge
	commit.
* merge commit parents — another one of those that I didn’t fully
	understand, but it turned out I was able to live without. Now I know
	that `^1` refers to the first parent of a merge commit, and `^2` to
	the second. I have always preferred rebasing to merging, and this way
	I just avoided it. After this tutorial I just can’t not get it. :)
* you can chain multiple ~N\^N for — this is a geeky one: HEAD~2\^2 reads
	as “the second parent of the commit before the 3rd last” :)
* `revert` vs. `reset` — I knew and used both of them, but in this
	tutorial I have found a new way to look at them: use `reset` to undo
	commits that are not published on any remote, and revert for the
	others.
* `cherry-pick` accepts multiple SHAs (!) — I think I have tried that at
	some point and it didn’t, so I’m glad I found out that it now does.
* clarified `fetch` and remote branch merging — this is definitely
	easier seen than read — and this is one that I think it’s bigger than
	others and I’m even more glad I “got.” I now understand where those
	merge commits come out when I pull, and more importantly: how to
	prevent them. :)

So, in the end, even if I knew how to do most of the things in the
“Advanced” section of the trail, I’m glad I have walked through it.
