---
layout: post
title: Promise array sequence
date: '2016-11-08T11:51:03+02:00'
---
The other day at work, as during a proof-of-concept task, I needed to
take a screenshot of a list of HTML pages, but massage them a bit before
that. The list of pages could be long so I needed them to run in
sequence.

The screenshotting function was Promise-based so I needed to chain the
promises so that they run sequencially. I know
[async](http://caolan.github.io/async/) could have made this easy, but
because it was a proof-of-concept I didn’t want to bring in any library.

So, 2 steps:

* massage the page a bit;
* take a screenshot;

This is what came out:

```js
var pages = [1, 2, 3, 4, 5];

console.log('Start!');

pages.reduce(function(work, page) {
  return work.then(function() {
    console.log('- massaging the page', page);
    return screenshot();
  });
}, Promise.resolve())
.then(function() {
  console.log('All done!');
})
.catch(function(error) {
  console.error('Failed:', error);
});

function screenshot() {
  return new Promise(function(resolve, reject) {
    setTimeout(function() {
      console.log('+ taking the screenshot');
      resolve();
    }, 500);
  });
}
```

\* * *

As simple as it is I couldn’t get it working from the first pass. This
depressed me, but later in the day I thought I’d give it another try and
understand what I was missing.
