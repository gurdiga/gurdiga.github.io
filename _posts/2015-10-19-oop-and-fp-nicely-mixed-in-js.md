---
layout: post
title: OOP and FP nicely mixed in JS
date: '2015-10-19T04:39:42+03:00'
---
OOP wants together behavior and data that change together. FP wants
behavior and data separate so that the behavior can be used with more
than one kind of data. JS makes the two collaborate well “for a greater
good.”

In one of my side projects I have widget classes: `FieldLabel`,
`DateField`, `Section`, etc. Most of them are “appendable”: they expose
the `appendTo` method that allows them to add themselves to a DOM
element.

For example, a `DateField` needs a `FieldLabel`. Instead of exposing
`FieldLabel`’s DOM element, I use its `appendTo` method:

```js
function TextField(labelText, value) {
  var domElement = document.createElement('text-field');

  var label = new FieldLabel(labelText);
  label.appendTo(domElement);

  // ...
}
```

Now I want `TextField` appendable too, so I want an `appendTo` method on
it that’d do the same thing as it does in `FieldLabel`:

```js
function FieldLabel(labelText) {
  var domElement = document.createElement('label');

  this.appendTo = function(parentDomElement) {
    parentDomElement.appendChild(domElement);
  };

  // ...

}
```

In conventional OO this would be done with inheritance: the `appendTo`
would go into a superclass and then both `TextField` and `FieldLabel`
would inherit from it.

In FP it can be frmulated in two ways: I need a function that given a
DOM element would return a function to append another DOM element to it.

A little side note: I didn’t intend to have it _The FP Way_®, I think it
just comes naturally with JS. :-)

So what came out is a high-order function:

```js
function getAppenderOf(domElement) {
  return function(parentDomElement) {
    parentDomElement.appendChild(domElement);
  };
}
```

and now I can use it in both classes like this:

```js
function WhicheverWidget(labelText, value) {
  var domElement = document.createElement('some-tag-name');
  // ...

  this.appendTo = getAppenderOf(domElement);

  // ...
}
```

The name is not perfect English, but it seems to express well what it
does.
