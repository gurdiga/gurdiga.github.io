---
layout: post
title: 'My own hackathon: day 11'
date: '2015-05-29T22:08:07+03:00'
---
It looks like I’ve caught a cold during my travel. Happy Friday. :-|

Today, after setting Google Analytics, I tried to find a working setting
to write automated tests.

I’m looking for something that would:

* Exercise the code in a manner as production-like as possible — the
	less mocking the better.
* Run packaged as a chrome extension — although in theory it should be
	very little difference compared to running in the browser, I want to
	be able to run tests on “the real thing.”
* Be lightweight — I know this is a buzz-word, but still I want it: I
	want it to be quick, and being small and lightweight is one good way
	to get to quick.
* Be robust — allow me to do sync and async tests without too much fuss.

For now tape is the one that I’ve picked. But I’m still to find a good
way to test this kind of code.

I’m not thrilled to go with React’s Jest, because I want tests to be
reliable and do as little magic as possible. Ideally I want to poke at
DOM myself and see it doing what I expect it to.
