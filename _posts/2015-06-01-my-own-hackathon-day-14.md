---
layout: post
title: 'My own hackathon: day 14'
date: '2015-06-01T15:52:50+03:00'
tags: []
---
This is the last day of this sprint. I’m far from an MVP, but I have
scratched the surface of what’s possible and this gives me some more
visibility for the next steps.

Today I woke up with a single small plan in mind: to test-drive a small
React component, to get a feel about how it’s done in practice.

It worked out pretty well: I was pleasantly surprised to find it
possible to render a component to a in-memory DOM element created with
`document.createElement()`. The test came out without a lot of magic,
which I highly appreciate. It seems like for now triggering a DOM event
like `change` doesn’t also trigger the corresponding React event, but
the workaround was pretty clean with the `Simulate` module from the
React’s test utilities.

It’s a small step that gives me the necessary motivation and clarity to
take on the next small step towards the goal of growing a maintainable
app.

In the context of automated testing, and test code I was thinking a lot
about accidental complexity: how much the library/framework/tooling gets
in your way and obscures the domain logic. During the weekend one other
thought related to that popped out: what about my production code? I
felt like React may be a bit too loud or ceremonious in its ways, and
later in the day I went and browsed the code on GitHub, and aside from a
few things related to code organization inside the file, I must say that
I was surprised about how understandable the code was. Very nice! 8-)

I have also thought about the file naming convention and decided to try
to name the component file name as the component class: for example
`TextField.jsx`, I think it’s more natural than having to mentally
translate it to someething like `text-field.jsx`. It’s a small thing,
but I like to improve everything I can.

Regarding the internal file structure, I think the `render` function is
the first thing that I want to see when I open a component file. I think
it reads better, so I’ll also try a new way to organize React pieces in
a file.

Overall, looking back at these two weeks, it seems to me that there is a
lot more to building an app than typing in the code, or as they say


> Typing is not the bottleneck.

Most of the work poured into an app is not typing, and now I think that
we may have the wrong name for “hackathons.” The original word —
marathon, defined as:

> A contest of endurance.

— is at least a bit different from what I think about when I hear the
word hackathon, which seems to be close to its definition:

> Hackathons typically last between a day and a week in length.

When I think about software development, it seems to me that “marathon”
fits a lot better. In some ways I think it’s like speed reading: I could
probably read a page per minute, but the amount of ideas that I’m able
to digest is a lot less, and I think it’s even more true when it comes
to inventing and building things.

My plan now is to continue with similar small steps. On the website I
have given the users a timeline of 6–12 months, so, good luck to me! :)
