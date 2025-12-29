---
layout: post
title: JS promise recursion
date: '2015-11-18T20:31:53+02:00'
tags: [js]
---
The other day I wanted to get some data from an API. The API is giving
the information paginated, so I have to fetch it page by page.

I like to work with promises for things like this and I went on and
googled “loop promise.” Found a few implementations, but I didn’t like
them because they were a bit too technical and low level: the code
didn’t communicate well the intent. So I set out to just write the code
as close as possible to how I would express this logic to a human being.

With some irrelevant details omitted, here is what came out:

```js
function downloadData(level, section, subsectionName) {
  var filePath = getFilePath(level, section, subsectionName);

  return collectAllRows().then(saveToFile(filePath));

  function collectAllRows() {
    var startPage = 1;
    var allRows = [];

    return requestNextPage(startPage, allRows);
  }

  function requestNextPage(pageNumber, allRows) {
    var apiRequestParams = section.getAPIRequestParamsForBulkDownload(subsectionName, pageNumber);

    return queryAPI(apiRequestParams)
    .then(collectRowsInto(allRows))
    .then(delay(DELAY_BETWEEN_REQUESTS))
    .then(requestNextPagesWhileThereIsPossiblyMoreData(pageNumber, allRows));
  }

  function requestNextPagesWhileThereIsPossiblyMoreData(pageNumber, allRows) {
    return function(numberOfRowsFetchedWithLastRequest) {
      var isTherePossiblyMoreData = numberOfRowsFetchedWithLastRequest === BulkDownloadOptions.PAGE_SIZE;

      if (isTherePossiblyMoreData) return requestNextPage(pageNumber + 1, allRows);
      else return Q.Promise.resolve(allRows);
    };
  }

  function collectRowsInto(array) {
    return function(result) {
      var rows = result.rows.map(function(row) { return row.cell; });
      array.push.apply(array, rows);
      return result.rows.length;
    };
  }

  function saveToFile(filePath) {
    return function(rows) {
      fs.writeFileSync(filePath, JSON.stringify(rows));
    };
  }
}
```

Some of the googled implementations would have probably got the job done
too, but I think this has less technical abstraction baggage within it,
and I like it when code is closer to the domain.
