---
layout: post
title: Testing promise-based JS code
date: '2014-04-25T17:59:00+03:00'
---
One tricky thing about testing promises is that they handle errors
thrown by their .then() callbacks. So I have a test like this:

```js
describe('#createUser', function() {
	it('returns a promise that is resolved with the passed in password', function(done) {
		authenticationService.createUser(login, password)
		.then(function(value) {
			expect(value).to.equal(password);
			done();
		});
	});

	// more tests...
});
```

and if you later change something that makes this test fail — so here
value will not be equal to password — then this test simply times out.
But why?

I remember when I first find out about Mocha — the test runner I use — I
found it curious how it has assertions working:


> Mocha allows you to use any assertion library you want, if it throws
> an error, it will work!


So, to tell Mocha about a failed assertion Chai simply throws an error.
But, because that error is in the context of a promise, it’s simply
“swallowed” by that promise. The other part of the story is that the
done() is never called either simply because something just threw before
it, so it never got to say that the test is done executing.

To get around that I wrapped the handler function containing the
assertions in a setTimeout call. I ended up with a little helper called
runAsyncAssertions which does that and a also passes on the received
arguments:

```js
function runAsyncAssertions(assertions) {
	return function() {
		var args = [].slice.call(arguments);

		setTimeout(function() {
			assertions.apply(this, args);
		});
	};
}
```

and I use like this:

```js
authenticationService.createUser(login, password)
.then(runAsyncAssertions(function(value) {
	expect(value).to.equal(password);
	done();
}));
```

Neat! I carried this bug in my head for weeks, so I was very happy to
finally understand and find a nice way around it.
