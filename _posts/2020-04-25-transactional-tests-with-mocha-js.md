---
layout: post
title: Transactional tests with Mocha.js
date: 2020-04-25 21:39 +0300
tags: [coding, tdd, js, side-projects]
categories: []
---

This week, while working on the email change scenario on [my side project][0], I realized that my tests are not transactional, which meant that their changes to the DB could persist across test runs and so tests could influence each other. Hm... I thought I fixed this before.

[0]: https://github.com/gurdiga/repetitor.tsx/

The whole idea of _transactional tests_ comes for me [from RSpec][rspec], and I was surprised when I was unable to google anything about it in the context of [Mocha.js][mocha].

[rspec]: https://relishapp.com/rspec/rspec-rails/docs/model-specs/transactional-examples
[mocha]: https://mochajs.org

So, I’m using Mocha.js for my test suite, and [`mysql`][1] NPM module for my persistence, and here is my initial take on this, [about a month ago][3]:

[1]: https://www.npmjs.com/package/mysql
[3]: https://github.com/gurdiga/repetitor.tsx/blob/153b5a7f45c879b2781728a48df5ee248797edf9/backend/tests/src/TestHelpers.ts#L13-L24

```ts
connectionPool.config.connectionLimit = 1;
connectionPool.on("connection", connection => {
  beforeEach(() => {
    connection.beginTransaction(e => {
      if (e) {
        throw e;
      }
    });
  });

  afterEach(async () => connection.rollback());
});
```

The concept is quite straight forward: have top-level `beforeEach` and `afterEach` hooks that begin a DB transaction before every test, and roll it back after, correspondingly. Although this code seemed reasonable at the time, the catch here is that the `connection` event only happens when the first query is run, and so, these hooks are set long _after_ they should have been. I guess that my tests at that time didn’t have a scenario that would make this issue clear, and so it slipped through.

Now, here is [the new setup][4], based on the new understanding:

[4]: https://github.com/gurdiga/repetitor.tsx/blob/e3c51b815aecbcc34e491fe195755c83f8436bc1/backend/tests/src/TestHelpers.ts#L14-L29

```ts
before(makeTestsTransactional);

async function makeTestsTransactional() {
  connectionPool.on("connection", (connection) => {
    beforeEach(() => {
      connection.beginTransaction((e) => expect(e).not.to.exist);
    });

    afterEach(() => {
      connection.rollback();
    });
  });

  await q(`SELECT 'Trigger "connection" above to wrap tests in a transaction';`);
}

```

The code is pretty much the same as before, with the exception of the last line, where I run a fake SQL query right away, just to trigger the `connection` event early and have the global hooks set as soon as possible.

As a bonus, I also added a verification after all the tests are run, specifically I expect all my application tables to be empty:

```ts
after(expectEmptyTables);

async function expectEmptyTables() {
  const tablesToExclude = ["migrations", "sessions"];

  const tableNames = (await q(`SHOW TABLES`))
    .map(({Tables_in_repetitor_test: tableName}) => tableName as string)
    .filter((x) => !tablesToExclude.includes(x));

  const getRowCount = async (tableName: string) => (await q(`SELECT * FROM ${tableName}`)).length;
  const getTableTuple = async (tableName: string) => [tableName, await getRowCount(tableName)] as [string, number];

  const rowCounts = Object.fromEntries(await Promise.all(tableNames.map(getTableTuple)));
  const expectedRowCounts = Object.fromEntries(tableNames.map((n) => [n, 0]));

  expect(rowCounts, "some tables have rows after running tests").to.deep.equal(expectedRowCounts);
}
```

It’s quite dense, but not unintelligible: I essentially list and query all the application tables, then `expect` that they each have 0 rows.

OK, that’s better. Happy testing!
