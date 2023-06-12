---
layout: post
title: Thoughts on Redux
date: '2016-03-30T08:00:43+03:00'
tags: [js]
categories: []
---
Last weekend I’ve watched the
[free introduction on Redux](https://egghead.io/courses/getting-started-with-redux)
and I think I got it. Redux has:

* app state — a JS object that represents the source of truth;
* reducers — JS functions that transform the state;
* actions — JS objects that are passed to the reducers¹;
* stores — they aggregate the first two, and also offer means to
	announce state changes to the view;
* view — the code that can display the app state to the user.

The state can only be changed by dispatching actions to the store,
probably by some UI events but can be any other source. The action
mention a specific transformation which is carried on by the reducers.
Then views can subscribe to changes on the store and render. It’s not
concerned how the data initially gets into the “app”, nor how is it
displayed.

It tries to encapsulate all the code that changes the app state, and
that organization sounds similar to back-end + front-end at a larger
scale in a web app:

* app data that lives in a DB (state);
* data can only be changed by the server code (reducers);
* data is displayed by the front-end (view);
* front-end sends HTTP requests that describe how to change the data
	(actions);
* app server execute the code (store);

The good part about Redux is that the overall idea is quite familiar,
it’s only at a smaller scale, in the browser.

One other thing that I liked about it is how non-magical it is: it’s all
pure JS code that is quite realistic to understand. I like that. Maybe
it’s subjective, but this gives me some kind of peace of mind.

One other collateral benefit to me personally it that it clarified a bit
more
[Elm’s approach](https://github.com/evancz/elm-architecture-tutorial/)
to app structure. 8-)

There is one thing that didn’t quite settle in my mind about Redux,
though. By trying to be The Authority® on state change, it also hiders
cohesion: now the knowledge about data structures are spread apart
between the reducers and the view, and it’s up to the programmer to keep
them in sync.

Maybe that’s how it’s meant to be² and I have to just deal with it.
Maybe. I just prefer cohesion lately.

I tend to get more defensive lately in my code, and there was a thing in
Redux that rang a bell to me: the reducer ignores unknown actions. I’m
not sure what is the reason for that, but I think I would have preferred
to throw an error.

There are a couple more things in that video course, but I’m going to
leave them out for now because I haven’t seen them used in the field.

———

¹ Conceptually they seem to be similar to the
[request objects](http://www.coreworks.co/adventures-with-clean-architecture)
in Uncle Bob Martin’s Clean Architecture.

² Maybe those are layers similar to the ones in MVC?
