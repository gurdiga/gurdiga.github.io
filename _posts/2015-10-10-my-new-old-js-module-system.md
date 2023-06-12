---
layout: post
title: My new old JS module system
date: '2015-10-10T17:07:41+03:00'
tags: [js]
categories: []
---
A few months ago I’ve switched one of my side projects from CommonJS
modules to plain JS namespaces, and in this post I’ll explain why.

I’ve started with CommonJS (Browserify) modules initially because I have
had a nice experience with it on a previous project.

The short version for why I switched is that having a single page, I
needed to bundle all my application code into one file on every change,
ad it was getting too slow.

My workflow was:

1. make a change
2. run make to run linting and bundling
3. refresh the test runner page in the browser

Step (2.) was the long one. Thanks to `make`, I made
[linting check](https://github.com/gurdiga/xo/tree/2e5bd103ff1f8528ce8ad3c27eb5d0ef8930de79/makefiles/lint)
only the files that changed since last linting. But bundling with
Browserify was technically impossible to do incrementally: it _had_ to
read all the application files, build their dependency tree, and poor
everything into one file. And then do that again for the test bundle.

When my `make` command got close to 2  seconds I decided to rethink my
build. So I changed from this:

```js
// somewhere in app/widgets/TextField.js
modue.exports = TextField;

// somewhere in a client module
var TextField = require('app/widgets/TextField');
```

to this:

```js
(function() {

  // somewhere in app/widgets/TextField.js
  window.App.Widgets.TextField = TextField;

})();

// somewhere in a client module
var TextField = window.App.Widgets.TextField;
```

The only other thing that changed is that when I added another module I
had to add a `<script>` tag in my `index.html`. For production mode it’s
easy to bundle everything with something like
[`hashcat`](https://www.npmjs.com/package/hashcat).

Now my `make` takes abut half a second.
