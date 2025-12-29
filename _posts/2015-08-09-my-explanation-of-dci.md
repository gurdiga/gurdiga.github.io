---
layout: post
title: My explanation of DCI
date: '2015-08-09T17:44:01+03:00'
tags: [coding]
---
In the [episode 21](http://giantrobots.fm/21) of “Giant Robots” podcast
Jim Gay is invited to talk about the DCI concept. The
[original document](http://www.artima.com/articles/dci_vision.html)
explains it with an example about saving accounts. Jim tries to explain
it with an app user. I find both examples somewhat unhelpful, and
thinking about this subject a little more, I think I found a better one.

A person: me.

* When I go to dig a ditch in my backyard, I equip with special gear,
	and usually do not talk much.
* When I go to a wedding I wear special clothes and try to be open to
	random conversations and body moves (dance).
* When I go to work, I wear my work clothes, make sure to get my laptop.
* When I go to the gym (supposedly), I wear specialized clothes and
	gear, and move in ways that are very specific to this context.
* When I’m home I can walk around in underwear and usually talk about
	home and family things.

I am the same entity, but for in different contexts I expose a
corresponding set of behaviors and qualities.

It seems to me that it makes sense to keep my gym gear at the gym, and
all my other specialized gear in separate closets or places close to
where the action takes places. And for the same reasons, the DCI way of
organizing code make sense, with a bonus for mapping so well to the real
world concepts.

It seems reasonable not to have all the gear with me all the time. It
seems reasonable not to debate design patterns over dinner with my wife
and kids. And for the same reasons, it makes sense for an object to only
have some kinds of behavior when the context requires it.

It is acceptable for the gym to have a schedule and some common-sense
rules for the different people that come there: trainers and trainees.
Same goes for wedding parties: they have lots of orchestration. And for
the same reasons, it makes sense to have use-case objects that contain
the orchestration logic.

I like it because leads to code that maps neatly to real world concepts,
which makes it easier to evolve the system with the business.

In JS I would implement roles with the
[decorator pattern](http://wiki.c2.com/?DecoratorPattern), but I think
everyone has their favorite approach in their favorite language.
