---
layout: post
title: Oiling promise chains
date: '2015-01-20T09:51:00+02:00'
tags:
- js
- promise
---
When working with asynchronous procedures in Node, I find promise chains help me write pretty readable linear-looking code:

```js
return getUserList()
.then(processUsers)
.then(disconnectDB)
.catch(logErrorAndExit);
```

Sometimes during a promise chain I find that at step 5 I want to access the data as it was at step 2, before it was processed. For example: I fetch some data from an API, run some computations on it, format an email with the results, and then send it. After making sure that the email was sent, I also want to save the fetched data in my DB, but at this point I can’t get it from the promise chain alone.

```js
return getPreviousSearchResults(user.aid)
.then(getCurrentSearchResults(user.clientList))
.then(findNews)
.then(assertNotEmptyNews)
.then(prepareEmailBodies)
.then(sendEmail(user.email))
.then(recordCurrentSearchResults(user.aid, ???))
.catch(handleErrors);
```

After the email is sent, I need to pass recordCurrentSearchResults() the data as it was returned from getCurrentSearchResults().

What I did is, I initialized a temporary container, inserted a step after getCurrentSearchResults() just to collect that data, then pass the container into the recordCurrentSearchResults() later in the chain:

```js
var searchResultSets = {}; // <-- the container

return getPreviousSearchResults(user.aid)
.then(getCurrentSearchResults(user.clientList))
.then(collectIn(searchResultSets, 'current')) // <-- collect the data
.then(findNews)
.then(assertNotEmptyNews)
.then(prepareEmailBodies)
.then(sendEmail(user.email))
.then(recordCurrentSearchResults(user.aid, searchResultSets)) // <-- pass the data
.catch(handleErrors);

function collectIn(container, key) {
  return function(value) {
    container[key] = value;
    return container;
  };
}
```

I used an object for the container so that I can pass its reference to recordCurrentSearchResults and later fill it later when promises in the chain resolve. I like it, but I’m wondering if there are other approaches to this.
