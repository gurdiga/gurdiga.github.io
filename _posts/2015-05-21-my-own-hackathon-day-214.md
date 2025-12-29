---
layout: post
title: 'My own hackathon: day 2/14'
date: '2015-05-21T10:47:18+03:00'
tags: []
---
I wasn’t very productive on day 2. I have burned the first half of the
day trying to write the least meaningful test and failed. I admit that I
was not prepared for that: both Chrome apps and React are new to me, and
it’s just too much struggle. Both are unlike anything I have worked with
so far and for the sake of making at least some progress, I will first
get more familiar with them.

While trying to unit test a button’s action I found myself lost in a too
fancy dance around React. It felt a bit too much fuss compared another
recent side project where I had raw OO JS for the logic and raw HTML.

For example, I have a Navigation decorator object that given a nav
container with links, it only shows those that are appropriate given
user’s authentication state. For example, it hides the logout link if
the user is not authenticated. And in Navigation unit test I get the
actual nav on production page¹, pass it to Navigation, and then inspect
how the links changed with chai-jquery. It makes for really reliable and
clear tests, and I would have liked to have both of these qualities here
too.

¹ It is slower than building an in-memory mock DOM structure, but I have
the assurance that I’m testing the right thing, plus I don’t have to
maintain the same structure in two places.

I have added my first couple of React components, one React mixin to
compensate for React Dev Tools extension not working in Chrome apps, and
a date formatting util wrapping moment.js. Fiddled a bit with the layout
and entry form’s CSS.

I’ll continue with the entry form.
