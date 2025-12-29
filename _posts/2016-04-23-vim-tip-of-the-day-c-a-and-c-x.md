---
layout: post
title: 'Vim tip of the day: C-a and C-x'
date: '2016-04-23T17:16:55+03:00'
tags: [vim]
---
They say that in Ruby if you think “I’m wondering if there is a function
that does X” then it probably exists. More and more I find that is true
about Vim too.

In Vim, if I have the cursor on a number and press `^a`, the number is
incremented. If I press `^x` it is decremented. Although it may not seem
to be extremely useful, I find myself using it often enough that I don’t
forget it.

One neat trick about `^a` and `^x` is that it works even if you’re not
on exactly the number, but somewhere on that line, before the number.
For example if I have this:

```js
var style = {
  paddingLeft: '2px'
};
```

if I’m anywhere on the second line before the “2”, `^a` will increment
it. Vim knows what I want to do! 8-)

Today I was writing a mock:

```js
function handler1() {
  handler1.calls = handler1.calls || [];
  handler1.calls.push({ args: arguments });
}
```

and a few minutes later I wanted the second one, similar to this, but
with “2” everywhere instead of “1.” OK, so I selected the `handler1`
function, copy-pasted it and *intuitively*, selected the copied code and
pressed `^a`. What do you think happened? All the “1”s in the selection
got incremented! Wow! 8-)

Well, almost: it turns out it applied the `^a` command to every line,
which increments the first number on that line, so I was left with a “1”
on the second line, where I have two of them.

Nevertheless it’s still awesome UX.

\* * *

After writing this I have cheched the documentation of `^a` and found
another neat trick:

```
*v_g_CTRL-A*
{Visual}g CTRL-A    Add [count] to the number or alphabetic
  character in the highlighted text. If several lines are
  highlighted, each one will be incremented by an
  additional [count] (so effectively creating a
  [count] incrementing sequence).  {not in Vi}
  For Example, if you have this list of numbers:
    1.
    1.
    1.
    1.
  Move to the second "1." and Visually select three
  lines, pressing g CTRL-A results in:
    1.
    2.
    3.
    4.
```

They say that even after years of Vim usage, it can still surprise you
with new tricks, and today is another of those days when I understand
how true this can be. :)
