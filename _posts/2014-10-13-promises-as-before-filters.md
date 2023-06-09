---
layout: post
title: Promises as before filters
date: '2014-10-13T11:21:00+03:00'
---
The Firebase JS library is callback-based, which feels pretty cumbersome after I got used to promises. So, the other day I wanted to have a FirebaseClient object that given a Firebase URL and credentials would give me a simple way to read and write data to it, something like this:

```js
var data = new FirebaseClient(url, secret);

data.get('/some/path')
.then(useTheData);

data.set('/some/path', value)
.then(announceSuccess);
```

In Firebase you can have “public” databases that can be accessed anonymously, and “private” databases that you can still connect to anonymously, but can’t access any data before you authenticate: connection and authentication are two separate and disconnected in time steps. You can technically connect and try to access the data, but for a private database you’ll get a permission error.

So in my FirebaseClient’s get and set I would have to first ensure the authentication finished and only then try to access the data, both of which are async callback-based calls.

In synchronous worlds like Rails, you achieve this with synchronous before_filters, but this is not how it works in callback-based JS.

It turns out that it’s pretty easy to get code that is comparably clear with the synchronous before_filters if I wrap the authentication in a promise:

```js
function FirebaseClient(url, secret) {
  var ref = new Firebase(url);
  this.authenticate = authenticate(ref, secret);
}

function authenticate(ref, secret) {
  // return a promise to authenticate
}
```

then make it a prerequisite in methods that need authentication finished before doing their own work:

```js
FirebaseClient.prototype.get = function(path) {
  return this.authenticate.then(get(path));
};

function get(path) {
  // return a function which does the actual data access
}
```

Before being resolved, the authenticate promise will queue everything that is then()ed on it. After it’s resolved, it will just just pass through to the subsequent then() calls. Nice! :)
