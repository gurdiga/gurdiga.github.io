---
layout: post
title: Switching from tape to Mocha
date: '2016-05-28T10:00:55+03:00'
tags: [coding, tdd]
---
I have a side-project where I use tape for testing. A few days ago I
stumbled on a test that I thought should fail, but passed.

The issue was what some people call “interacting” tests. The state of
the world of that test was being influenced by the ones before it. I
think it’s because I’m used to the Mocha/Jasmine style of test suite
organization, and I assumed that the tests I had at the same level of
nesting are independent.

I had one more similar issue before and I looked for a way to get
different setup and teardown for different branches of the test suite.
I’m not the first think about this, and found a
[discussion](https://github.com/substack/tape/issues/59) in a GitHub
issue. I found the proposed workarounds inelegant and I rejected them
because I want my tests to be clear and explicit.

So I decided to switch to Mocha. It has a test suite organization
similar to Jasmine and rspec. Switching testing frameworks is not a
trivial task but I think that long term it’s good to have a robust one.
