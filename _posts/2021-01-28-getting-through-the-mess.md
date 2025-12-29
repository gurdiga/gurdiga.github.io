---
layout: post
title: Getting through the mess
date: 2021-01-28 09:52 +0200
tags: []
---

Every now and then I end up in a messy codebase. It’s scary and discouraging to try to fix a bug in there.

One approach that I’ve used again recently in an Angular legacy codebase is housekeeping (aka refactoring): I try to make the least sense possible of the mess and extract small pieces, the smaller the better, and if available, I try to use the editor’s refactoring features to avoid typos and fat-thumbing.

Because the component class was written in TypeScript, one thing that made the refactoring easier was to introduce types. It makes me sad to see how types are underutilized in Angular. My codebase was no exception, that’s understandable, but seeing that in libraries makes me sad.

Introducing missing types, or replacing `any` acts as a quick support structure for making bigger changes, and also makes it easier to find bugs.

Extracting utility functions also helps. I found myself introducing small libraries of functions: ArrayUtils, DateUtils, NumberUtils, StringUtils. These are easy to reason about and straightforward to unit-test. Bit by bit, they too help to chip away at the mess.

I wish Angular had an easier way to extract components: to break a large messy component into smaller messy components which I can then work with. I worked with React for the last few years, and I loved how easy was to extract a function component: it’s just a function.

Sometimes it just needs a bit of time: I just go through the code again and again trying to make sense of it. The first time most of it is unfamiliar and makes no sense, but as you navigate through it, again and again, the brain starts to make connections, and pieces begin to fit together.

It also helps to split this over more than one day. If I slug through a mess for more than a few hours straight, I get exhausted and can’t make any progress. On the next day, it makes more sense, and more connections start to appear.

No rocket science.
