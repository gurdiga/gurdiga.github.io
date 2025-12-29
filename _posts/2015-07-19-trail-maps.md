---
layout: post
title: Trail maps
date: '2015-07-19T14:19:41+03:00'
tags: [coding, learning]
---
I don’t have a CS degree, and most of what I know I’ve learned along the
way because I found it interesting or because I needed to solve a
problem. It worked pretty well so far, but sometimes I feel like I need
a bit of structure around it, usually when I’m trying to make sense of a
bigger picture.

On one of the episodes of the “Late Nights with Trav and Los” podcast —
“[Steal a College Education](http://www.travandlos.com/23)” — they
recommend searching for courses online. This is not news, but the big
idea that they emphasize is that most of them have a table of contents
or an outline of the course, and that’s exactly what I want: that is the
_structure_ I’m looking for, and if I have that, it’s usually easy to
find articles or tutorials on specific subjects.

Although not that explicitly worded in a problem-solution format, I do
something similar. I often take a course — book, a series of articles,
or a video series — and “walk” it from cover to cover even if I think
that I already know the material. I find it helpful in two ways:

* it adds some more structure to my knowledge
* most of the time I learn new things, new aspects of the things I
	already know, or new ways to looks at them

Incidentally, I’ve stumbled upon the [thoughtbot’s trail-maps](https://github.com/thoughtbot/trail-map) on GitHub. It’s a
collection of well structured materials for the subjects they teach at
the [apprentice.io](http://www.apprentice.io/) project.

So I took the challenge to walk some of the trails, and here I want to
share the new things I’ve learned.

## Heroku

I am a user of Heroku for my last couple of years and I thought I know
enough to make good use of it. But as often the case, I still found new
things in the materials in [the Heroku trail-map](https://github.com/thoughtbot/trail-map/blob/master/heroku.md)
— mostly from the “[Professional Heroku Programming](https://www.amazon.com/Professional-Heroku-Programming-Chris-Kemp/dp/1118508998)”
book. Here are some of them:

* clarified what dynos are — it’s the Linux equivalent of FreeBSD jails
* clarified that word that I see during deploys — “slug” — it’s a
	ready-to-spawn package of your application which includes a specific
	version of the app code and its dependencies, plus any other build
	steps applied to the code; they use it for easy scaling and release
	management
* how HTTP routing works on Heroku — essentially how a request gets to
	the application and the implications of that:
	* SSL termination happens before the request gets to the application
	* load balancing is fully automatic — you can’t control which request
		to which instance, and this excludes the ability to have sticky
		sessions
	* max response time: 30s
	* HTTP keep-alive time: 55s
* the idea of pace layering — this is another¹ concept borrowed from the
	building construction domain — which suggests an interesting way to
	think about software decomposition. So the pace here refers to the
	expected rate of change:
	* the foundation and load-bearing walls almost never change
	* the in-building communications can change more often
	* painting on the walls can change even more often

Because of the cost of change for each of them is different, the
decision process is different too. We have to make similar decision when
we envision our software. It’s a way to look at the application
components/layers from the change-in-time perspective, and it seems to
connect to [Uncle Bob’s definition of SRP](https://8thlight.com/blog/uncle-bob/2014/05/08/SingleReponsibilityPrinciple.html):
parts of the app that change together should live together.

* the idea of erosion resistance — Heroku restarts all the dynos every
	day. This seems silly and even annoying at first, but this single
	little constraint has a few nice implications on the platform
	resiliency and overall health, and but also on the app:
	* this allows for platform and application dependency updates
	* prevents software “erosion” — the degradation of the app in time as
		it runs like memory leaks and log files filling the file system
	* automatic app restart on crash; if it crashes again, it’ll leave it
		alone for 10 minutes before retrying
	* automatic dyno migration when the hardware server on which it runs
		crashes
	* it encourages you to build your app in a manner similar to
		[Erlang’s let-it-crash](https://community.embarcadero.com/blogs/entry/let-it-crash-programming-37819)
* you can manually restart the app with `heroku ps:restart`
* you can run an interactive shell command on the dyno with `heroku run`
	— yeah, a trivial thing, but one which I found useful
* when the dyno manager sends SIGTERM to the app, it waits 10 seconds,
	so you can use that time in the app to gracefully shut down
* found how [the “The Twelve-Factor App” theory](https://12factor.net/)
	applies
* found interesting things about Postgres:
	[forking](https://devcenter.heroku.com/articles/heroku-postgres-fork)
	and
	[following](https://devcenter.heroku.com/articles/heroku-postgres-follower-databases)

So, yeah, it’s been a useful walk. Thank you thoughtbot for putting this
together. :)

¹ the other being the “pattern” concept term borrowed by Kent Beck from
[Christopher Alexander’s “A Pattern Language”](https://www.amazon.com/Pattern-Language-Buildings-Construction-Environmental/dp/0195019199)
