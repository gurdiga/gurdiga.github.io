---
layout: post
title: On testing UIs
date: '2015-10-31T10:46:17+02:00'
---
I have heard that people resist testing UIs because “they change often”,
and my oppinion is that from the perspective of “tests as safety net” UI
testing is as valuable as any other kind of testing.

One argument that I hear often is:

> UI changes often.

Yes, as all the other code, and this is why we have regression tests in
the first place.

If I decide to make a change in the UI, there is value in it, and I want
a test to make sure that value is kept. If there is no value in a
change, maybe it’s not worth making at all.

Even Mr. Robert Martin said in a related article entitled
[When TDD doesn’t work](https://8thlight.com/blog/uncle-bob/2014/04/30/When-tdd-does-not-work.html):

> How do you know if the CSS is correct?

and then

> Anything that requires human interaction and fiddling to get correct
> is not in the domain of TDD, and doesn’t require automated tests.

Ouch!

With all due respect to Mr. Martin, I think that the conversion is not
about CSS, that is only an implementation detail.

Interfaces are defined as various elements that are arranged in a
specific way to accommodate a specific work process. And if I can be
specific about how I want those UI elements arranged, I can write a test
for it, and Mr. James Shore
[demonstrated](https://github.com/jamesshore/quixote) a particularly
nice way to do that.

I think that if code is valuable enough to be written in the first
place, it deserves to have tests.
