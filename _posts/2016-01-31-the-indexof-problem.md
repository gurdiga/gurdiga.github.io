---
layout: post
title: The indexOf problem
date: '2016-01-31T13:10:49+02:00'
tags: [js]
---
I have recently read this article
“[Don’t Make Me Remember Things](https://8thlight.com/blog/rob-looby/2016/01/28/dont-make-me-remember-things.html)”
where the author complains about string’s `indexOf` method having
less-than-ideal API. Specifically, about the case when the sought
substring is not found: `indexOf` usually returns a nonsense value like
`null` or `-1`, and the developer has to remember that, which leads to
bugs.

On second thought though, it seems like there are two problems mixed in
this story:

1. whether the substring is found at all,
2. what is the exact position.

And if I look at `indexOf` this way, I would probably have 2 variables,
explicitly covering for both of those purposes:

```js
var index = string.indexOf(substring);
var isFound = index !== -1;

if (isFound) doSomethingAbout(index);
else doSomethingElse();
```

and in this case, there is no problem with forgetting.

To that this idea a littl further, I would probably have a different
function to check the inclusion:

```js
function containsSubstring(string, substring) {
  return string.indexOf(substring) !== substring;
}

if (containsSubstring(string, substring)) {
  var index = string.indexOf(substring);

  doSomethingAbout(index);
} else {
  doSomethingElse();
}
```

This version is calling `indexOf` twice, and there can be cases where
this is a performance issue, and then I’d stick with the first approach.

\* * *

It’s another case where an issue is unconfortable to deal with because
it’s actually more issues mixed together, and, which are simpler when
taken apart.
