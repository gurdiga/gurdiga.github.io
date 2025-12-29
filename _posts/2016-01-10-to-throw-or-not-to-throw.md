---
layout: post
title: To throw or not to throw
date: '2016-01-10T22:00:59+02:00'
tags: [programming, patterns, js]
---
I’m working on a little basket widget, and while thinking about the
model I caught myself unsure about how to handle validation errors. For
example: while instantiating a new `Product`, I need its ID, name and
price, but what should I do when price is not a number?

I realize that I have very little experience with error throwing, and I
don’t have a “usual” way. So, to throw or not to throw?

If I don’t throw, I would have to somehow fill in for the invalid
values, which implies making some decisions. For example: what should I
set the price to when it’s not valid? Maybe I can leave it undefined? Or
null? This doesn’t smell right at all. Maybe I could pick the closest
value: zero. But this would mean to paper over the fact that the input
value was not good, and can lead me into some confusing situations.

If I throw, I would have to account for that in the client code. This
makes the a bit more code noisy, but, at least is explicit; and there
will be one less source of NPEs.

OK, so I will throw. Im guessing the I’d get the best ROI from it if
I’ll do it early in the process. The earlier I pass through the
potentially throwing code, the earlier I get to “solid ground” where I
can stop worrying about invalid values.

One such place is when loading the page, I will check if there is a
persisted data, and try to restore the basket content from it.

Whichever the persistence method, it’s outside of my code and I can’t
guarantee that the persisted data is perfectly valid, so the Basket
model initialization the is the earliest — and so the best — possible
moment. Rejecting the invalid data at the boundary of the system
minimizes the effort to deal with it: I’ll need less checking, less
error handling, which means more straight-forward code, and hopefully
less bugs.

Sounds good.
