---
layout: post
title: Faster TypeScript build with project references
date: 2020-03-22 18:04 +0200
---

This weekend I have finally got to optimizing the TypeScript build for [my side project][1]. Because page bundles included both shared modules — one for the code shared between the backend and the frontend, and one for the code shared between the pages — they were getting longer to compile.

[1]:https://github.com/gurdiga/repetitor.tsx/

The plan was conceptually quite straight-forward: have each of the shared modules as their own bundle, and let the pages _[reference][2]_ them instead of _[including][3]_ them. Ideally, this would mean:

[2]: https://www.typescriptlang.org/docs/handbook/project-references.html
[3]: https://www.typescriptlang.org/tsconfig#include

- any page bundle would only re-compile when its own code has changed;
- changes in the two shared modules wouldn’t require pages re-compilation.

All in all, the outcome that I was after was a faster build.

On the downside, because the two shared modules would now be bundled separately, I’ll now have two more requests for every page, but I decided it’s worth the trade, and I will return to this later.

In a nutshell, I went through all the 10 `tsconfig.json` files in the project and did 2 changes:

- use `references` instead of `include` where it made sense — this had the biggest impact;
- set `baseUrl` to the project root — this results in uniform and explicit imports across all of the project modules, although just a tiny bit longer;
- drop `paths` settings — because I couldn’t get them to work with project references.

Although it’s only three points, the [commit itself][4] touched 88 files because it has lead to changing import paths everywhere. Despite the scary number of files, VSCode made it quite manageable: I think it took me a few hours on a cozy Saturday.

[4]: https://github.com/gurdiga/repetitor.tsx/commit/beafbe8353e01d797be12b07c4333c7b63bcd143

Now the watching build is faster, which means better frontend development experience, the server start is faster which means better backend development, and the [pre-commit hook][4a] is faster.

[4a]: https://github.com/gurdiga/repetitor.tsx/blob/e722a56/Makefile#L111-L113

A collateral change that I’ve done during this work was that I have switched the two shared modules to the [AMD module format][5] because I need to load them into the browser, and then switched all the rest of the modules to AMD format too, just to have less variation across the project. I expected this to degrade the build speed because now all of each module’s TypeScript files are bundled into a single JS file instead of each file separately, but a quick measurement didn’t show any difference.

[5]: https://github.com/amdjs/amdjs-api/wiki/AMD

To get the Node tooling working with the AMD module format, (`mocha` and the backend server Node) I brought in the [`amd-loader`][6] NPM module.

[6]: https://www.npmjs.com/package/amd-loader

I have attempted this build optimization a couple of times before, and couldn’t get it to a working state, which made it even more exciting for me.

The next technical tweak that I have in mind is to optimize the loading of shared and page bundles. Stay tuned.
