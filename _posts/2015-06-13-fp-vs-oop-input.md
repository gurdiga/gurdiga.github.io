---
layout: post
title: 'FP vs. OOP: input'
date: '2015-06-13T13:05:01+03:00'
tags: [js]
---
I often think about how Functional Programming (FP) compares to Object
Oriented Programming (OOP).

One aspect is how do we provide input to functions. FP promotes small
functions that given the same input return the same output. It seems
that being forced to pass input as argument results in smaller functions
because more params usually means more work, which means larger
functions. Larger functions are harder for client code to use because
you have to remember what are all those arguments.

One other side-effect is that if a function get its input through
arguments, it’s also easier to reuse in other contexts.

One example would be the pluck function:

```js
function pluck(propertyName) {
  return function(object) {
    return object[propertyName];
  };
}
```

I can use this to get the amount for items in a cart:

```js
cart.items.map(pluck('amount'));
// [1, 2, 1, 3, 1]
```

or, to get the list of comment IDs for an article:

```js
article.comments.map(pluck('id'));
// [523, 524, 580, 587]
```

Small size seems to result in a more generic function, which does less
things — ideally one, and which is more reusable.

In OOP, functions are bound with the data that they operate on. So if
I’d have an object for every context, I would have a separate method for
each of them. For example, with a `Cart` class I would have something
like this:

```js
Cart.prototype.itemAmounts = function() {
  return this.items.map(function(item) {
    return item.amount;
  });
};
```

and then, for with the `Article` class I would have something like this:

```js
Article.prototype.commentIds = function() {
  return this.comments.map(function(comment) {
    return comment.id;
  });
};
```

Both of these methods: `Cart.prototype.itemAmounts` and
`Article.prototype.commentIds` do a very similar thing: iterate over a
collection of items, and for every item collect a given property. This
is ([incidental?](https://www.youtube.com/watch?t=374&v=Is8ThG6Fetg))
duplication.

With OOP methods do not explicitly receive the input, it’s enclosed in
the instance context. This requires more effort to understand the code:
you have to look into it body to see what it does.

On the other hand, having `article.commentIds()` is more concise than
`article.comments.map(pluck('id'))`. It also results in better
encapsulation: it doesn’t expose how comment IDs are collected, which
leads to less coupling.

I have used both approaches and they both work. The choice seems to come
down to which is more familiar to the programmer.
