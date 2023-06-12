---
layout: post
title: On DHH on TDD
date: '2014-05-01T10:46:00+03:00'
tags: []
categories: []
---
It’s not that I could argue with DHH regarding TDD—in technology he’s at
a level that I may never reach. Mr. Kent Beck had his say on that
article, and also Mr. Robert C. Martin, although not as to-the-point as
Mr. Beck’s.

I have little to say about the article itself. My take is that DHH
simply had a bad day. Generally speaking, when I hear that kind of tone,
I tend to think that the author just had a hard time with the subject of
the story. Bit by bit it accumulated and now it exploded. And this tells
more about author’s misuse/misconception of the subject rather than
about the subject itself.

Anyway, I think this is a good time to look at my own TDD practice and
tell how it works for me.

1. Coming from a recent failure with a “legacy” codebase, having a
	 single command that tells me that everything is fine after a change
	 is a Pretty Big Deal™.
2. It helps me to look at my production code from another developer’s
	 perspective: would this method name make sense with these arguments?
	 When I write my test first, I have the answer.
3. It helps keep units small. If I have a big setup for the test, this
	 is telling me that that module may be doing too much.
4. It helps me limit the dependencies. This is a variation of the
	 previous: if I have a big setup and I have to prepare a lot of
	 dependencies to inject, this tells me that I may need to rethink that
	 unit.
5. It helps me document the functionality. I have moments when I come
	 back to a piece of code I wrote a few weeks ago and I can’t remember
	 why I did it that way. With good tests I can make peace with that.

Sometimes I write tests for configuration or default
settings. I confess that I had mixed feelings about that in the
beginning, but later I realized that in case I get those settings wrong,
I will also have to change tests, which makes it harder to make
mistakes. Later I found Mr. Martin’s analogy to double-entry
bookkeeping, which is basically the same reasoning.

The conclusion I have for my relatively short first-hand experience with
TDD is that it really helps me do a better job as a developer.
