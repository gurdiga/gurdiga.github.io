---
layout: post
title: Why I like function hoisting in JS
date: '2015-09-30T12:00:45+03:00'
tags: [js]
categories: []
---
There is this phenomenon in JS called “function hoisting.” It’s regarded
as odd to newcomers but I found it improving code readability and use it
every day.

The easiest way to explain it is to start with  a piece of code:

```js
var result = getComputedValue();

function getComputedValue() {
 // do some computation and return some value
}
```

This is valid code. The idea is that the function getComputedValue can
be used before it’s defined.

Here is how I used it today while defining a new widget for my side
project:

```js
function SentenceSubjectSection() {
  var domElement = createDomElement();
  var fields = createFields();
  var section = new Section('Obiectul urmăririi', fields);

  // more “main” code…

  function createDomElement() {
    // the details...
 }

  function createFields() {
    // the details...
  }

  // more function definitions...

}
```

I like it because I can see what’s going on at the “big picture” level.
It makes is easier to orient myself: I can first decide which of the
larger conceptual pieces I want to look at, and then dive into its
details.

One convention that I use to keep this sane is that I put all of the
actual function definitions under  main body of code. So when I see a
function definition I know that main code ended, and here come the
details.
