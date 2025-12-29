---
layout: post
title: 'My own hackathon: day 1/14'
date: '2015-05-19T19:44:16+03:00'
tags:
- hackathon
- webapp
- development
---
I wrote about this app for bailiffs that I started to build and failed.
I also wrote that some a couple of weeks ago I went with my partner to a
former colleague of his — a bailiff — to interview him and see how he
actually works and if there would be any value in building an app for
them.

My partner was pretty optimistic and open towards giving it a try, by
for me conclusion was not clear at all. After going back-and-forth in my
mind for last couple of weeks, I decided I should take some time off
from my day job, build as much of a working prototype as I can, and show
it to people. This will give me a much clearer answer.

During the weekend I decided to try: I took 14 days off, to go build it.
And, to make the whole thing more interesting, I want to write as much
as I can about this process.

So, today I have set the infrastructure to get a “hello world” up and
running: linting, building, and testing.

Because of the clear concern regarding the personal information privacy,
I decided to build it as a Chrome App: all the data will be stored
locally on the user’s computer. It’s essentially a single page web app
that runs on top of the Chrome engine, outside the browser itself, and
from what I’ve read the platform has a pretty impressive feature set.

At least in the beginning, most of the work will go into building the
UI: I’m thinking about two basic functions: add/edit information, and
search. And because the UI will be pretty dynamic, I decided to go with
React.js.

I’m not sure how much automated testing I should do for now, but one
notable aspect of my setting is that I decided to get React’s modularity
a step further by bundling the unit tests with the component itself. It
sounds like a neat idea, but will see how it plays out.Here is a summary
of tooling:

* UI library: React.js
* build tool: make
* JS modules: CommonJS with Browserify
* automated testing: Mocha with Chai

If you’re curious about how it looks, you can check it out on Github.

Overall, although I was a bit nervous in the morning, I’m content with
what I have achieved on my first day. Tomorrow I want to start building
the actual UI. I’m thinking to let the beauty aspect aside for the
moment and get the bones together first. I also don’t want to think
about how to store the data, what database to use. Not yet.
