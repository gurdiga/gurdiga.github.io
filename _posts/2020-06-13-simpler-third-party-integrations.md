---
layout: post
title: Simpler third-party integrations
date: 2020-06-13 16:07 +0300
tags: []
categories: []
---

I would like to tell how I have done the third-party service integrations on [my side project][1]. Email, file storage, error logging are a few examples.

[1]: https://github.com/gurdiga/repetitor.tsx/

For every integration there is a wrapper module which contains the nitty-gritty details of the service integration, and exports one or more functions that represent the basic operations that the wrapped integrated service provides:
- [`EmailUtils`][2] exports `sendEmail`;
- [`FileStorage`][3] exports `storeFile` and `deleteStoredFile`;
- [`ErrorLogging`][4] exports `logError` and `errorLoggingMiddleware`;

[2]: https://github.com/gurdiga/repetitor.tsx/blob/ad3cffa/backend/src/EmailUtils.ts
[3]: https://github.com/gurdiga/repetitor.tsx/blob/fbe1e8a/backend/src/FileStorage.ts
[4]: https://github.com/gurdiga/repetitor.tsx/blob/738cb65/backend/src/ErrorLogging.ts


This setup allows me to easily stub the third-party service in unit tests and keep the app code unaware of the details of specific services.

This is a pretty neat arrangement actually, and because of that I like to push the idea of what a third-party service is: How about wrapping the Markdown parsing? How about wrapping the DB?

I have a `Markdown` module that exports the `parseMarkdown` function. Now I can use that function and my app will never know what specific Markdown parsing library I use. This makes it easy to change it later if needed.

I have a `Db` module that exports the `runQuery`, and now the app doesn’t need to be concerned with any specifics of the API of the particular SQL library. ORM? Promise-based API? Callback-based API? — The wrapper module contains all of that so that the app code can be straightforward.

Containing the third-party service integration complexity into a wrapper module also allows me to unit test that service separately. I chose my tests to interact with the real service; it can be slow, but this gives me the peace of mind that automated tests are expected to give. To work around their slowness, I only run them once from the Git pre-commit hook, with the exception of the time when I work on them specifically.

How about wrapping the app server? — I can do that too. I have separated the code that deals with the request-response life-cycle in a separate module [`Adapter`][5] and this allows me to have the backend code as [plain functions][6] that receive values and return values.

[5]: https://github.com/gurdiga/repetitor.tsx/blob/4f340a7/backend/src/Express/Adapter.ts
[6]: https://github.com/gurdiga/repetitor.tsx/tree/88b01dc/backend/src/ScenarioHandlers

What I like best about this setup is that it allows me to keep the different subsystems unentangled, and so, manageable.

Happy integrating!
