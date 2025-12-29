---
layout: post
title: My HTML & CSS trail map
date: '2015-08-02T16:36:55+03:00'
tags: [html, css, learning, web]
---
2 articles ago I started a little study by following
[thoughtbot’s trail maps](https://github.com/thoughtbot/trail-map).
After Heroku and Git, I’ve picked [HTML &
CSS](https://github.com/thoughtbot/trail-map/blob/master/html-css.md),
and today I will write about the things I’ve learned from it.

I have skipped most resources in the “Beginning HTML & CSS” section
because I nodded most bullet points in its “You should be able to” list.
Except for
“[A Beginner’s Guide to HTML & CSS](http://learn.shayhowe.com/html-css/)”:
I like online guides because they are usually more up to date than
(printed!) books. Here are some new things that I found/clarified:

* article vs. section vs. div — I think I finally “got” what’s the
difference between them: “Both the `<article>` and `<section>` elements
contribute to a document’s structure and help to outline a document:
	* If the content is being grouped solely for styling purposes and
		doesn’t provide value to the outline of a document, use the `<div>`
		element.
	* If the content adds to the document outline and it can be
		independently redistributed or syndicated, use the `<article>`
		element.
	* If the content adds to the document outline and represents a
		thematic group of content, use the `<section>` element.”
* path relativity — it turns out that the terms “relative” and
	“absolute” have a slightly different meaning in the context of links
	compared to file system paths. “Links pointing to other pages of the
	same website will have a relative path, which does not include the
	domain (.com, .org, .edu, etc.) in the href attribute value.”
* inline elements can have vertical padding! — it doesn’t affect their
	position in the flow, but if the element has border or background, it
	is quite visible, and it may even have a good use-case, some day… :)
* clarified `box-sizing` property — I knew what it is and how it affects
	the layout, I even knew how to google and copy/paste the
	[right snippet](https://css-tricks.com/box-sizing/) to make things
	work right, but I never got too close to it to find what other kinds
	of box sizing there are.

For the “Intermediate HTML & CSS” section I have enjoyed diving into
both [diveintohtml5.info](http://diveintohtml5.info/) and
“[HTML5 for Web Designers](https://abookapart.com/products/html5-for-web-designers).”

One notable idea I have found in both resources is how HTML evolves and
how its specs are written: it’s not that someone thinks really hard and
comes up with a thorough document on what tags should there be and how
should they work. It’s more like one of the browser vendors tries
something and depending on how much web developers like and use it, the
other browser vendors come along and implement it too, and then W3C and
WHATWG say: “Hmm, this thing seems to have caught up, let’s write a
spec!” And this is useful because it helps align the browser vendors and
align everyone’s understanding of that thing.

diveintohtml5.info gives the
[intro to canvas](http://diveintohtml5.info/canvas.html) that kept me
from falling asleep, and also lots of get-your-hands-dirty info in the
[chapter on video](http://diveintohtml5.info/video.html); same for
[geolocation](http://diveintohtml5.info/geolocation.html) and
[offline](http://diveintohtml5.info/offline.html).

The “HTML5 for Web Designers” book also had something new for me:

* although before you were not allowed to have block elements inside
	inline elements, you can do that in HTML5: specifically you can put
	block elements inside the `<a>` element without breaking it. If I
	think about it this is a pretty pragmatic decision: there were so many
	times when I wanted to have, for example, a header, an image, and a
	paragraph all linked to somewhere, and I had to link each of them
	separately.
* a reasonable use-case for canvas: “The real power of canvas is that
	its contents can be updated at any moment, drawing new content based
	on the actions of the user. This ability to respond to user-triggered
	events makes it possible to create tools and games that would have
	previously required a plug-in technology such as Flash.”
* the `datalist` attribute: “The new  datalist  element allows you to
	crossbreed a regular input element with a select element. Using the
	list attribute, you can associate a list of options with an input
	field”
* there is a `mark` tag! — “a run of text in one document marked or
	highlighted for reference purposes, due to its relevance in another
	context.”
* the concept of markup _portability_ and _sectioning_ content: “In
	HTML5, I don’t have to worry about which heading level to use. I just
	need to use sectioning content — an article element.”

Picking the HTML & CSS trail map I thought I would take it easily — I
have started playing with HTML when IE3 came out, and we are good
friends ever since. I still think that HTML with CSS are the most robust
publishing and layout platform.

Although I thought it would be an easy trail to walk. And even if I have
read most of the resources in the “Advanced HTML & CSS” section long
before this, even I used to read specs on w3.org cover to cover, and
followed [ALA](http://alistapart.com/) since recently, it wasn’t that
easy of a walk.

While reviewing the notes for this article I realized that “build a
fluid grid” still sounds scary to me. I know that part of it is that I
have never needed to build/use one, and the fear will melt as I will get
closer to it.

This trail ended up with a weird experience. At some point I felt a bit
of anxiety: “I just can’t keep up with all these things.” It’s
terrifying. But then I realized that that’s OK. Are there surprising new
ways to solve problems for people and build useful things? Perfect! This
is a sign that the world evolves, and this is a good thing.

UPDATE Jul 10 2021: One of my readers shared another link: [https://www.websiteplanet.com/blog/html-guide-beginners/](https://www.websiteplanet.com/blog/html-guide-beginners/). — Thanks Alyn!
