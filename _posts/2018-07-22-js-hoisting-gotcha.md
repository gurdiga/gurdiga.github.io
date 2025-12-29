---
layout: post
title: JS hoisting gotcha
date: 2018-07-22 13:49 +0300
tags: [js, coding]
---

I have [written]({% post_url 2015-09-30-why-i-like-function-hoisting-in-js %})
why I like function
[hoisting](https://developer.mozilla.org/en-US/docs/Glossary/Hoisting) in JS,
but the other day I got a bite in the back in the context of function hoisting.
😸

The context was something like this:

```
export var productCollection = new ProductCollection(jsonData.concat());
```

And I needed to add a transformation to this collection, so I thought I’d have
a `massage(json)` function, so that it’d end up like this:


```
export var productCollection = new ProductCollection(massage(jsonData));
```

And, of course I would like to make use of function hoisting and have my
function defined somewhere at the bottom, so that I keep the first things coming
first. Good, let’s do it: I need to have each product’s category names in
a specific order. So:

```
export var productCollection = new ProductCollection(massage(jsonData));

function massage(json) {
  var CATEGORY_ORDER = [
    "Red",
    "Orange",
    "Yello",
    "White",
  ];

  return json.map(function(p) {
    return p.categoryNames.sort(function(c1, c1) {
      return CATEGORY_ORDER.indexOf(c1) - CATEGORY_ORDER.indexOf(c2)
    );
  );
}
```

Um… I don’t need to create that `CATEGORY_ORDER` array on every function call,
let’s pull it out of the function:

```
export var productCollection = new ProductCollection(massage(jsonData));

var CATEGORY_ORDER = [
  "Red",
  "Orange",
  "Yello",
  "White",
];

function massage(json) {
  return json.map(function(p) {
    return p.categoryNames.concat().sort(function(c1, c1) {
      return CATEGORY_ORDER.indexOf(c1) - CATEGORY_ORDER.indexOf(c2)
    );
  );
}
```

Looks good, let’s see if it works. And…

```
Cannot read property 'indexOf' of undefined!?
```

Huh… A few minutes went by while staring at the code…

Ooh!! I see: the function definition is hoisted, so when I call it before its
use, it works fine. The tricky part is the variable hoisting: only variable
_declaration_ is hoisted — its assignment is left where it is, so, at the
runtime the code looks more like this:

```
var CATEGORY_ORDER;

function massage(json) {
  return json.map(function(p) {
    return p.categoryNames.concat().sort(function(c1, c1) {
      return CATEGORY_ORDER.indexOf(c1) - CATEGORY_ORDER.indexOf(c2)
    );
  );
}

export var productCollection = new ProductCollection(massage(jsonData));

CATEGORY_ORDER = [
  "Red",
  "Orange",
  "Yello",
  "White",
];
```

So at the time when the function is called, the `CATEGORY_ORDER` is only
declared, but not yet assigned, which means it’s value is `undefined`, and so
the error message now makes perfect sense:

```
Cannot read property 'indexOf' of undefined
```

OK. 🤔
