---
layout: post
title: 'My own hackathon: day 8/14'
date: '2015-05-26T20:28:01+03:00'
tags: [coding, hackathon]
categories: []
---
Today I worked on getting the data collection/population of the case
entry form.

This was the first of My 3 “Why Angular”s that I wrote about about a
year ago: I have large hierarchical dynamic form with lots of pieces of
data. With Angular this seems to be easy: you just define ng-model for
every field and that’s about it.

With React, I had to come up with my own approach: every component that
has a field where user can type data, gets a getValue() method that will
return the value of that field. If the component is a section, a
container for other field-components, it’s `getData()` will return a hash
with its children’s data, recursively. For example: for a
`PersonSection`, it’d return something like this:

```js
{
  'gen-persoană': 'fizică',
  'nume': 'Cutărescu Ion',
  'idnp': '01234556789',
  ...
}
```

and for a field-component, say `TextField`, it’ll return its HTML
input’s value. Although I have only used it for `PersonSection`
container component and for the field-components, it seems to work so
far.

The one thing that I’m trying to get working now is lists. For example
the case — the document in the bailiffs’ world — can have zero or more
third-parties. In JSON I’d express that as an array of person-like
hashes, but out of the box it doesn’t play well with my React model
where, for example, every `PersonSection` component has a `ref` name,
like `creditorul` and its `getData()` returns values in the child
field-components like this:

```js
{
  'creditorul': {
    ... // all the fields go here
  }
}
```

which in my `NewCaseDialog` component looks like this:

For third parties, I have an array like this:

```js
{
  'părţi-terţe': [
    { ... },
    { ... }
  ]
}
```

which doesn’t translate well to components having a `ref`. The way I’m
thining to go around this it by adding the array index to the ref name,
for example:

and then in `getValue()` detect these series of `ref`s and return them
all as an array under `persoane-terţe`, which should work.

It doesn’t right now, there is a bug somewere, and I think that it may
be time to start writing unit tests: I already feel the fear of breaking
things. The `Valuable` mixin that contain all the data
collection/population it’s getting a git hairy — although it’s only two
days-old — and I’m thinking to TDD it, just to see what would come out.

Since the web-based implementation of this — a few years ago — failed
exactly because of the mess that I made, it shouldn’t be a hard choice.
As Uncle Bob says:

> The only way to go fast is to go well.

I think he’s right.
