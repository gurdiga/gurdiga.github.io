---
layout: post
title: TypeScript on backend and frontend
date: 2020-01-13 08:45 +0200
tags: []
---

One awesome thing about side projects that I get out of a side project is that I get to try my fanciest ideas. On [the most recent side project][1], one thing that I got to try is sharing TypeScript logic and types between frontend and backend code.

Here is one way how this can be useful. A specific action, say user registration, has a set of possible error response codes, maybe the email is taken or the password is missing, or any number of reasons. I want my frontend code to be kept in-line with the backend code, and I can ask TypeScript to do check that for me. Type-check all the things!

In the code, I can define those error codes as a union type (or enum), and then use those types on both sides: the frontend and the backend. The simplest way I could think of was to have both of them in the same repo.

Good.

Now, the build. For the frontend I want to have a bundle per page. For the backend and don’t want to compile the backend at all because I don’t need it; it’s a little slower to start `ts-node`, but the overall build setup is simpler. Because of this difference in the build needs between frontend and backend, I need separate `tsconfig.json`s.

One note about the compilation and bundling: I’d love to have `tsc` do that itself if possible, which [turns out it is][2].

One other thing about build is that I’d like it to stay fast as the project grows. One way I found to do that with TypeScript is to use [project references][3]. It’s this concept where you can structure your codebase as a concert of multiple projects that can reference each other. Thanks a lot to Ryan Cavanaugh for the [sample repo][4] that shows how it’s done — it’s been very helpful.

Here are 2 things that this concept does for me:

1. separate `tsconfig.json`s for the frontend and backend;
2. build caching, which means faster builds in the long term.

Good.

[1]: https://github.com/gurdiga/repetitor.tsx
[2]: https://medium.com/@vivainio/with-latest-typescript-you-may-not-need-webpack-417d2ef0e773
[3]: https://www.typescriptlang.org/docs/handbook/project-references.html
[4]: https://github.com/RyanCavanaugh/project-references-demo
