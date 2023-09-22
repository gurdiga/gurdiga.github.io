---
layout: post
title: Speeding up my TypeScript build
date: 2020-05-10 22:25 +0300
tags: [coding, build, ts, side-projects]
categories: []
---

I was cleaning up my NPM modules on [my side project][0]. Since almost from the beginning, I have had 2 “child” package.json files, one for the backend and one for the frontend, and the “main” one in the project root.

[0]: https://github.com/gurdiga/repetitor.tsx

It kind of made some sense from the keeping-things-tidy perspective: most of the modules needed on the backend will not be needed on the front-end. Just common sense, on the one hand. On the other hand, the simplicity of having one `package.json` was also attractive, so today, after a routine update of NPM packages, I gave it a try.

A quick tangent: Before updating the NPM packages, I checked the latest Node.js version: 14.2.0; `nvm install`ed it, gave it a try, and after a 4 or 5 rounds of `make clean build test` I realized that it was 2 seconds faster than the 13.1.0, from 56s to 54s. Huh, OK, it’s not much, but if it’s an improvement, and it works, why not?! — [let’s do it][1].

[1]: https://github.com/gurdiga/repetitor.tsx/commit/89681cc675ca113adcc25f2945fa3dcc40e71fa8

Now, back to the idea of consolidated `package.json`. I have copied all the things from the backend and frontend `package.json`s, into the root one, and run the clean build: from the 54s it went to 61s. Ran it a few more time, same thing. Hm. That’s sad. After pondering a bit, I decided it’s not worth doing this change because it’s going to slow down my development builds by ~7% constantly. OK, at least I’ve learned something.

Now, if consolidating package.json files made the build slower, would having more of them, smaller, make it faster? — Let’s check! I moved some of the modules from the root to backend, and introduced a new `package.json` in `frontend/tests` — there were a few modules in the frontend `package.json` that were not needed for the “production” frontend code. Ran the clean build again, and, ta-da!! — it went from 54s to 50s. Ran it a few more times just to make sure, and yeah, it’s faster! 8-)

Interesting, isn’t it? Could it be related to my project being [composite][2]?

[2]: https://www.typescriptlang.org/docs/handbook/project-references.html#composite
