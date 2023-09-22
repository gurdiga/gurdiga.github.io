---
layout: post
title: "My new favorite thing: Type systems"
date: 2017-04-08 12:14
published: false
tags: [js, ts, types, coding]
categories: []
---

*Note: This article is valuable for JavaScript developers that find it
unreasonably hard to maintain their code.*

At its core, programming is describing the app behavior: precisely, and down to
the smallest detail. What data does it takes in, and what does it do with it. So
a good programming language should have means to describe data, which seems to
have two aspects:

- creating data structures initially;
- ensuring their integrity as we change and pass them around.

With JavaScript, one thing that I appreciate about creating its data structures
is the balance between simplicity and composability:

```js
var price = 3.14;
var title = "Haskell Programming from first principles";
var isAvailable = true;
```

Nothing more that is necessary, and it’s as simple to compose those bits into
more complex data structures:

```js
var product = {
  id: 512,
  title: "Haskell Programming from first principles",
  price: 3.14,
  isAvailable: true,
  pageCount: 1879,
  tags: ["haskell"]
};

var products = [product, product2, product3];
```

I bet most humans can read an understand this, which is good because being able
to effortlessly read and understand code is valuable.

In any non-trivial program, besides creating these data structures we also need
to change them, and pass them between functions, and this is where the other
aspect of working with data structures becomes important: changing them and
ensuring their integrity.

With a dynamic language like JavaScript, the programmers have to do that
themselves: they just need to be careful. I came to realize that expecting this
of humans, even the most disciplined, is mostly impractical for any non-trivial
app. This is one of the things that makes programming unnecessarily hard.

And this is why I came to appreciate type systems: with a type system we can
delegate this to the computers; they are much better at doing tedious things
with great precision.

This is why I came to appreciate TypeScript: it allows us to keep what we have
in JavaScript, and gives us the ability to specify the relevant details about
our data structures so that it can keep them in check for us.

```ts
var price: number = 3.14;
var title: string = "Haskell Programming from first principles";
var isAvailable: boolean = true;
```

It may seem that it adds noise to the obvious declarations we had before, which it
does, and this is where _type inference_ comes in: We don’t need to specify
types when they are obvious. When we assign a value, TypeScript can figure its
type and make a note to itself, which means we can have our declarations as
simple as before:

```ts
var price = 3.14;
var title = "Haskell Programming from first principles";
var isAvailable = true;
```

…but, with the added support from TypeScript: it will make sure that we don’t
accidentally assign a string to a boolean variable, or pass it to a function
which expects some other type.
