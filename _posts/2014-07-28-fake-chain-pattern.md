---
layout: post
title: Fake chain pattern
date: '2014-07-28T19:41:55+03:00'
---
I have recently read “Smalltalk Best Practice Patterns” and since the
idea of pattern is fresh in my mind, I want to share a function naming
trick that I use many times.

In one of my toy projects I have recently come to the problem of writing
a JS function to find the “old items” in a list of “current items”. So I
have:

```js
var oldItems = [1, 2, 3];
var currentItems = [1, 2, 3, 4, 5];
```

and I need a function that would tell me which of the current items are
new. First question that comes out is: what do I name it? Then, in which
order do I pass the arguments in a way that is obvious which one is
which? Maybe it’s because I’m a long-time JavaScripter, but this whole
idea felt somewhat unnatural…

If I step back and think about this problem, it’s about two subjects—the
current and previous lists—so it seems more intuitive to think of this
as two actions: find the item in one and then check if it exists in the
other. Here is what I came up with:

```js
var newItems = itemsIn(currentItems).thatExistIn(oldItems);
```

This fake chain is pretty easy to implement in JS, but from the use
point of view is a lot better. The combination of the two function names
clearly tells what’s going to happen, and I don’t even have to think
about which list to pass where.

A similar approach is used by Jasmine testing framework:

```js
expect(message).toMatch(/bar/);
```


which reads pretty well too. In my case the implementation is pretty simple:

```js
function itemsIn(currentItems) {
  return {
    thatExistIn: function(oldItems) {
      // here I have both lists
    }
  };
};
```

It may feel a bit unnatural if you’re not too fond of JavaScript, but I
find it makes for really readable client code.
