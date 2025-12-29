---
layout: post
title: Me is back to work
date: '2015-06-02T19:52:42+03:00'
tags: [coding, tdd]
---
This my first day back to my day-job at Assembla. My plan is to find an
hour every day to work on my project.

I did this today. After I finished my Assembla tasks for the day, I
switched and got some meaningful work done. But I feel a bit tired; it
may be because it’s my first day after 2 weeks, and it was a bit of
effort to get up to speed after two weeks.

I’m going full-TDD now and gradually throw away the old components as I
implement new ones. As I said, it’s a long way to go and I don’t want my
confidence to decrease while growing the app. I like it how it goes so
far and I’m hopeful.

There is one thing that I’d like to mention regarding my today’s last
commit, here is the message:

```
Even if I’ve removed the label-related CSS from TextField and
SelectField I’m not deleting the tests that verify them because I don’t
want to depend on the implementation detail, which now it’s
`FieldLabel`.
```

The idea is that just before this I have implemented a new FieldLabel
for the common parts that I found in `TextField` and `SelectField`. And
now, although I was using this new `FieldLabel` component instead of
hardcoded markup, I still kept the markup and CSS-related tests for
those componentns intact.

I did this because I want to make sure that no matter how they are
implemented, I still want to verify that they have the appropriate
markup and CSS. Extracting `FieldLabel` is just an implementation detail
that test should not be concerned with. It sounds like a good idea, will
see how it plays out long-term. :)
