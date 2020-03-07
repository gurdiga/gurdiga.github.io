---
layout: post
title: My testing guideline
date: '2015-09-13T12:28:21+03:00'
---
I use one non-academic guideline that helps me decide what and how to
test in my code.

The guideline is this: If one day I find this thing not working, or
suspect that it’s not working, how would I manually verify it? Then I
write some code that does that.

If it’s a web UI’s layout that it’s broken, I would probably open the
browser console and inspect the DOM. I can do just that with JavaScript.

If it’s an external service wrapper, for example for Firebase, I would
probably execute it in the browser console and check the Firebase UI to
see that data changed as expected. I can get about the same effect using
the wrapped service’s library.
