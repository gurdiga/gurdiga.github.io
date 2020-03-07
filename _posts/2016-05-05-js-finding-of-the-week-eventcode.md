---
layout: post
title: 'JS finding of the week: event.code'
date: '2016-05-05T10:54:52+03:00'
---
This morning I was working on a `DropdownButton` widget:

![dropdown widget screenshot](https://drive.google.com/uc?export=view&id=0B2PFbI002LWPaUNCNEM5a2llTjA)

I wanted to implement keyboard control so that when it’s focused, I can
slect an option with the arrow keys. I begin with a new test that would
simulate a key press, so I wrote:

```js
simulateKeyDown(toggleButton, DOWN_ARROW);
// TODO: assert things
```

Now I need to define the `simulateKeyDown` function and the `DOWN_ARROW`
constant. The function can go somewhere below, but the constant I have
to define somewhere above. — I don’t like that because it’s noisy: the
constant definition is a test implementation detail, and I want it out
of the way.

Another option would be to defined it somewhere below in one of the
outer scopes. I usually do that with imports, but I don’t like that
either because it’s disconnected from the place where it’s being used.

I like the test code to be clear, and this constant definition didn’t
quite fit. I began to wonder wether this constant already exists
somewhere on the `Event` and I don’t have to define it at all. Went to
the browser console and poked around a bit, but without much success.

Then went to check the
[`KeyboardEvent` docs on MDN](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent)
and scanning the property list found that keyCode that I was using…

> *Warning*: This attribute is deprecated; you should use
> `KeyboardEvent`.key instead, if available.


`KeyboardEvent.key`!? What’s that? 8-\| Went back to the console, and typed:

```js
document.body.addEventListener('keydown', function(e) { console.log(e.key); })
```

pressed some keys and got a bunch of `undefined`s. Hm… not supported in
Chrome? 8-/ Went back to the property list, and found
[`KeyboardEvent.code`](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/code).
Playing with it in the console shows that it is supported. OK. So now,
instead of defining a constant for every key I need need, I can use its
string name:

```js
simulateKeyDown(toggleButton, 'ArrowDown');
```

That’s nicer! I can now have this little `simulateKeyDown` extracted as
a test helper and use it across the tests.

This is neat, and I wanted to find The Official® list of key names, so
that I know where to look for when I need another key. I googled around
and stopped on W3.org:
[UI Events KeyboardEvent code Values](https://www.w3.org/TR/uievents-code/#table-key-code-alphanumeric-writing-system).
Nice!

\* * *

It seems that browser support is not quite there for now: the code
property is implemented by Firefox and Chrome, and key is implemented by
Firefox and IEs.

In my case it’ll be an Elecron app, so I don’t have to worry about
browser support. 8-)
