---
layout: post
title: Timing promises
date: '2014-10-08T11:37:00+03:00'
---
I have a deeply nested loop of promises that query a remote API, and I
had them logging their time by default, like this:

```
...
jcm: 1745ms
jcr: 1765ms
jcl: 1935ms
je: 1750ms
...
```

Since a few weeks though, as the number of API requests grew, the output got so log that the message was being clipped by GMail. Today I thought I would review the logging and trim it a bit.

I had the timing code in a utility function interwoven with the other async flow control code, and now it was time to get it out of there. That code was pretty dense by itself, so I scratched my head a bit, but then I realized that it’s promise-based, and so I just cut the timing code out and wrote a little utility function that given a promise and a label, returns the same promise and logs its duration:

```js
function time(promise, label) {
  label = label.toString();
  console.time(label);

  return promise
  .then(function(response) {
    console.timeEnd(label);
    return response;
  });
}
```

Now I can use it to only time things that I want. I have another function that retrieves some data from a Firebase, and I wanted log that too:

```js
ClientLists.get = function() {
  return getFirebaseData('/data')
  .then(filterPayersAndTrials);
};
```

to log its duration I changed it to:

```js
ClientLists.get = function() {
  return time(getFirebaseData('/data'), 'getting client lists')
  .then(filterPayersAndTrials);
};
```

and now I get a nice timing log:

```
getting client lists: 1740ms
```

Nice! Now my log is nice and tidy.
