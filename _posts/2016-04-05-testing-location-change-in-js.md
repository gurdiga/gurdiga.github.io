---
layout: post
title: Testing location change in JS
date: '2016-04-05T08:00:22+03:00'
---
Every now and then I come across a scenario where I need to unit-test
some code that navigates across pages by directly changing location.
Some time ago I have accidentally stumbled upon a solution: the
[`location.assign()`](https://developer.mozilla.org/en-US/docs/Web/API/Location/assign)
function.

For example, if I have a button that first does some work and then
navigates to some other page:

```js
function handleClick() {
  saveTheDocument().then(function() {
    location = '/some/other/page';
  });
}
```

I can’t test this code because it will nevigate away from the test
runner’s page, so I loose the whole thing! 8-|

How does `location.assign()` help? Well, if I change my code to use `location.assign()` instead of direct assignment, like this:

```js
function handleClick() {
  saveTheDocument().then(function() {
    location.assign('/some/other/page');
  });
}
```

it works the same way, but I can now stub the `location`’s `assign`
method in tests, like this:

```js
describe('click handler', function() {
  beforeEach(function() {
    sinon.stub(location, 'assign');
  });

  it('navigates to the other page', function() {
    handleClick();

    expect(location.assign.calledOnce).toBe(true);
    expect(location.assign.lastCall.args[0]).toBe('/some/other/page');
  });

  afterEach(function() {
    location.assign.restore();
  });
});
```

I have packed the stubbing code into a `stubLocation` test helper, and
now I only have to say this:

```js
TestHelpers.stubLocation(beforeEach, afterEach);

describe('click handler', function() {
  it('navigates to the other page', function() {
    handleClick();

    expect(location.assign.calledOnce).toBe(true);
    expect(location.assign.lastCall.args[0]).toBe('/some/other/page');
  });
});
```

Neat! 8-)
