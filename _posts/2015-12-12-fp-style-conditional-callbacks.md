---
layout: post
title: FP-style conditional callbacks
date: '2015-12-12T14:16:47+02:00'
tags: [js]
categories: []
---
The other day I was putting together a little UI to collect emails: an
input and a button. So I wanted the email to be take in when the user
clicks the button:

```js
dom.events.add(submitButton, 'click', tryRegisteringEmail);
```

OK, but it’d also be neat if the user could just hit Enter. So I’d do
something like this:

```js
dom.events.add(textField, 'keypress', someSuggestiveHandlerName);
```

Yeah, but the keypress handler feels a bit out of line with the first,
it’s like it’s at a different level of abstraction. And then I thought,
so I need it to do the same thing as in case of the button click —
`tryRegisteringEmail` — but only if the pressed key was Enter. Here is
what came out:

```js
dom.events.add(textField, 'keypress', ifPressedEnter(tryRegisteringEmail));
```

Looks neat! Let’s code it:

```js
function ifPressedEnter(handler) {
  return function (event) {
    var ENTER_KEY = 13;
    var pressedKey = event.originalEvent.charCode;

    if (pressedKey === ENTER_KEY) {
      handler.call();
    }
  };
}
```

By the way, this `ifPressedEnter` function — because it accepts another
function as its input, and its return value is another function — is
called a “high-order” function in functional programming lingo.

This pattern came handy when I wanted to implement delegated event
handling. There was a list of friends, and some of them have a “Remind”
button. I thought I would be good to deletegate the clicks on those
buttons to a single click handler on the list element. Here is what came
out:

```js
dom.events.add(friendsListElement, 'click', ifClickedRemindButton(sendRemindMessage));
```

and the `ifClickedRemindButton` function looked like this:

```js
function ifClickedRemindButton(handler) {
	return function (event) {
		var element = event.target;

		if (isARemindButton(element)) {
				handler(element);
		}
	};
}
```

Another high-order function made my day a little bit better. :)
