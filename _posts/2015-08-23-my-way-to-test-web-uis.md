---
layout: post
title: My way to test web UIs
date: '2015-08-23T22:22:53+03:00'
---
I remember how amazed I was while reading Kent Beck’s “Test Driven
Development: By Example.” Automated regression tests sounded very
useful. But it was not obvious how to apply that in the context of web
UIs.

With a non-browser programming language, for example Ruby, it’s simple:
I have the test Ruby code which calls the production Ruby code, and
verifies that given a specific prepared context it behaves in an
prescribed manner.

But when I develop web UIs the picture usually includes three pieces:

* I start with HTML to build the UI elements: many times it’s a form
	with some fields and buttons.
* Then I add some CSS to arrange them appropriately and make the whole
	picture look nice.
* And then I add the JavaScript to validate the form, and probably send
	the data to server.

It is common to have the 3 kinds of code separated in different files.
But how do I write automated tests for this? What do I test?

In the end, the fact that there are 3 kinds of code involved, turned out
to be irrelevant for testing. And the simplest answer to “What to test?”
question is: What would I check (manually) to see if it’s still working?

And then I write a JavaScript test verifies that. In the beginning it
seemed a bit too much to test every property of every element, but then
I realized that if I added them, they are valuable, and so it’s worth
making sure they are still there.

Most of the time I have a separate HTML file for tests, and from there I
load the app in an iframe and have the test inspect it. This mechanism
[works](https://github.com/gurdiga/pinj-web-ui/blob/1b55d41a616630e07e2cc47d58dd006444c0f1ac/test/pages/smoke-test.js)
even if I need to navigate between pages, reload them, or submit forms.

So in the end, it turned out that testing web UIs it’s not a lot
different from testing anything else: you just verify what you need to
be there.
