---
layout: post
title: Timing out JS promises
date: '2014-09-17T09:32:00+03:00'
tags: [js]
categories: []
---
When wrapping an API client I found myself wanting to set a timeout for
promise-based methods. I first used setTimeout to reject the deferred
promise after a given amount of time, like this:

```js
UserService.prototype.registerUser = function(email, password) {
  var deferred = new Deferred();

  this.auth.createUser(email, password, function(error) {
    if (error) deferred.reject(error);
    else deferred.resolve();
  });

  setTimeout(function() {
    deferred.reject(new Error('User registration timed out: ' + email));
  }, TIMEOUT);

  return deferred.promise;
};
```

But when I needed this for another method, I thought it would have been
nice to have a timeout method on the deferred that would hide that noisy
setTimeout, and clearly express the intent. Now, because I had my own
wrapper for the promise library, it was relatively easy to add it,
without the fear to monkey-patch someone else’s library. So this is what
came out:

```js
Deferred.prototype.timeout = function(ms, message) {
  setTimeout(function() {
    this.inner.reject(new Error('Timeout error: ' + message));
  }.bind(this), ms);
};
```

And now, I can just say:

```js
UserService.prototype.registerUser = function(email, password) {
  var deferred = new Deferred();

  this.auth.createUser(email, password, function(error) {
    if (error) deferred.reject(error);
    else deferred.resolve();
  });

  deferred.timeout(TIMEOUT, 'Timed out on registration: ' + email);

  return deferred.promise;
};
```

Sweet! :)
