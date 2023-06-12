---
layout: post
title: My 3 “Why Angular”s
date: '2014-04-03T17:41:00+03:00'
tags: [js]
categories: []
---

In a previous post I said that I recently went to a JS meet up, and I
was left with the impression that the presentations would have been more
useful if they were more narrowly focused: maybe take a specific problem
and explain how a particular framework helps in solving it. Then I
thought, what exactly do I mean by that? So here is what.

## Population/collection of large forms¹

So, in my side project, I have a large form. Even more than that:
depending on the choices that users makes at some point, there may be
more fields added at the subsequent steps. With jQuery, you have to
write code that:

- finds those fields and populates them when you open the document
- finds those fields and collects data out of them into a structure to save

Yes, you can come up with clever conventions and tricks to make this nicer,
I’ve tried that, an my version was not that nice in the end. :-/

With Angular’s binding, you just add the ng-model attribute on inputs,
and you have all the data, all the time, in and out of the form, with
zero DOM walking. B-)

¹ I know large forms are a subject in and of themselves, but let’s say for a
moment that in my particular context this was OK. ;)

## Contextualization

What I mean by this fancy word is that you can easily figure out what
HTML element has what logic bound to it, usually just by looking at its
attributes in the markup, most of the time this is about directives,
controllers, form validation rules, and filters. With jQuery it’s pretty
easy to mess up by moving the element into the DOM tree or changing its
class, ID or attributes, which in both cases means the element’s
selector changes.

## Directives

This is in part about the previous fancy-word one, just from the
perspective of how it makes “componentization” (another invented fancy
word) of the UI easier by allowing you bind the structure/markup and the
behavior/JS code in a nice way.

The first point was enough for me to take a closer look at Angular, and
I was thrilled to find about the second two. I will talk about other its
goodies in another post.
