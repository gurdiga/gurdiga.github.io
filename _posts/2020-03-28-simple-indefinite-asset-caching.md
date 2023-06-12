---
layout: post
title: Simple indefinite asset caching
date: 2020-03-28 19:33 +0200
tags: []
categories: []
---

In my [last post][1] about my side project I have mentioned that I have extracted 2 shared bundles to increase my build speed, and one downside of that is that now have two more requests for every page, and this week I have implemented a small tweak that will compensate to that: _indefinite caching_.

[1]: {% post_url 2020-03-22-faster-typescript-build-with-project-references %}

As fancy as it may sound, it turned out to be [a small tweak][2] in my case, partly because I already had it implemented before for the vendor bundles, and partly because I have dreamed it a couple of nights already and had it almost coded in my head. 🙂

For the vendor bundles it looked like this: to be able to serve them with a maximum [`max-age`][3] in the `Cache-Control` header, I just added their NPM version number in the file name. For example, here is the path for the React module:

```
/vendor_modules/react-16.13.0.js
```

[2]: https://github.com/gurdiga/repetitor.tsx/commit/7e7efcac9728b73291348ca9818d181ad2e1200d
[3]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control#Caching_static_assets

This will allow me not to worry about it getting cached when I upgrade it. There is one nuance that I’d like to mention: I don’t bundle the vendor modules at all, I just serve them from the `node_modules` directory. Bundling them all into a “vendor” bundle would only increase the build time without much added value.

For the app bundles I use the Git revision as the version, so I have paths like this:

```
/home/bundle-21f11a9c3f6037c1b80372ad7b3aa8d36cd9e1c9.js
/shared/bundle-21f11a9c3f6037c1b80372ad7b3aa8d36cd9e1c9.js
/frontend/shared/bundle-21f11a9c3f6037c1b80372ad7b3aa8d36cd9e1c9.js
```

In production, Heroku exposes the Git revision in the `HEROKU_SLUG_COMMIT` env var, and locally I just set it to `development`.

All of this gives me a efficient and reliable caching model: the browser loads the JS files _only once per change_, both for the vendor and app bundles. Which means that after the first page load, the two additional bundles don’t make a significant difference, because the browser will not request any JS file twice, and the result is visible with the naked eye.

I am glad I could get this working with a [tiny slice of code][4] without an “asset pipeline” or an additional “module bundler” of any sort.

[4]: https://github.com/gurdiga/repetitor.tsx/blob/21f11a9c3f6037c1b80372ad7b3aa8d36cd9e1c9/backend/src/Utils/Express/Adapter.ts#L51-L52
