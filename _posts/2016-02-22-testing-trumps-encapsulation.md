---
layout: post
title: Testing trumps encapsulation
date: '2016-02-22T16:37:54+02:00'
tags: [unit-testing]
categories: []
---
At some point I have
[heard](https://8thlight.com/blog/uncle-bob/2015/06/30/the-little-singleton.html)
Uncle Bob saying that:

> Tests trump Encapsulation.

Although the meaning was a bit vague in that particular context, it
still got stuck in my memory.

While looking for a subject to write about, I realized that I
[am](https://github.com/gurdiga/xo/tree/master/app/widgets)
applying that principle too in my front-end code. For every widget I
have a `widget.appendTo(containerDomElement)` method, and to inspect its
output in tests, I give it a “sandbox” DOM element, and then inspect it
in that sandbox:

```js
var textFieldInput = new TextFieldInput(fieldValue);
textFieldInput.appendTo(sandbox);
```

I decided to do it this way instead of exposing widget’s DOM element
because I want it to be encapsulated. Having it public tempts the client
code to get too coupled to it.

For the `TextFieldInput` I expect it to render an HTML input tag with
the given value, so in tests I say:

```js
var input = sandbox.querySelector('input');
t.equal(input.value, fieldValue, 'renders an <input> with the given value');
```

Sometimes when I hear about privacy in the testing contexts I start to
doubt the rightfulness of this approach, but then I fall back to my old
guideline: How would I verify it manually if I thought that it broke in
some way?

The first thing that I would do is probably inspect it’s markup, either
with print statements, or with the browser’s DOM inspector. And that
sounds perfectly reasonable. In that context, its perfectly reasonable
to take a peek into its internals. The fact that the widget’s DOM
element is private to the client code is not relevant now. Or, as Uncle
Bob would say:

> What good is encapsulated code if you can’t test it?

Sounds reasonable.
