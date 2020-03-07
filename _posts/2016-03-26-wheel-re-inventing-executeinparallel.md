---
layout: post
title: 'Wheel re-inventing: executeInParallel'
date: '2016-03-26T16:25:08+02:00'
---
At my day job we often need to write low-level JS code without any
framework or library handy, and we often end up re-inventing some of the
wheels. `executeInParallel` is one of those wheels:

```js
// It’s used like this: say I have to do a few
// AJAX requests:

executeInParallel([
  users: getUsers,
  tasks: getTasks
], function allFetched(error, collectedResponses) {
  // If everything went well I get:
  // collectedResponses.users and 
  // collectedResponses.tasks populated.
})

function executeInParallel(tasks, callback) {
  var collectedResponses = {};
  var runningCounter = 0;
  var isInterrupted = false;

  tasks.forEach(function (task, key) {
    runningCounter++;

    // Each task function follows Node’s convention
    // to return the error, if any, in its first argument.
    task(function (error, response) {

      runningCounter--;

      if (isInterrupted) {
        return;
      }

      if (error) {
        interrupt(error);
        return;
      }

      collectedResponses[key] = response;

      if (runningCounter === 0) {
        callback(null, collectedResponses);
      }

    });
  });

  function interrupt(error) {
    isInterrupted = true;
    callback(error);
  }
}
```

It’s not rocket science, but it keeps our code clean and expressive. 8-)
