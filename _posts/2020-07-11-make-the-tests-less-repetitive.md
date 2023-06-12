---
layout: post
title: Make tests less repetitive
date: 2020-07-11 16:04 +0300
tags: []
categories: []
---

On [my side project][0], I strive to have as good of a unit-test coverage as I can. Because I define the input and every outputs of a scenario handler, there can be a lot of execution paths to unit-test, and so it can get pretty tedious to cover all of them. This is why I’m employing a technique that resembles [data-driven testing][1].

[0]: https://github.com/gurdiga/repetitor.tsx
[1]: https://en.wikipedia.org/wiki/Data-driven_testing

Here is an example: [AvatarUpload scenario handler][2], in the backend. [The scenario][3] result is defined like this:

[2]: https://github.com/gurdiga/repetitor.tsx/blob/88b01dc/backend/src/ScenarioHandlers/AvatarUpload.ts
[3]: https://github.com/gurdiga/repetitor.tsx/blob/b1f6750/shared/src/Scenarios/AvatarUpload.ts#L14-L22

```ts
export type AvatarUploadResult =
  | AvatarUrl
  | NotAuthenticatedError
  | UploadValidationError
  | UploadTempFileMissingErrorr
  | BadFileTypeError
  | CloudUploadError
  | ProfileNotFoundError
  | SystemError;
```

One good think that comes out of having the expected outcomes listed like this is that it makes it pretty clear what are the execution paths that I need to test.

The test for the happy path, the first in the list above, is usually more meaty, but the those for unhappy paths are quite uniform in both the setup and assertions, so I create a list of all the inputs and their corresponding expected outputs, and iterate through them:

```ts
describe("unhappy paths", () => {
  Object.entries({
    "when not authenticated": {
      input: {upload: []},
      session: {userId: undefined},
      expectedResult: {kind: "NotAuthenticatedError"},
    },
    "when upload parsing reports FileTooLargeError": {
      input: {upload: {kind: "FileTooLargeError" as const}},
      session: {userId: 42},
      expectedResult: {kind: "FileTooLargeError"},
    },
    "when upload parsing reports UnacceptableUploadError": {
      input: {upload: {kind: "UnacceptableUploadError" as const, error: "For some reason"}},
      session: {userId: 42},
      expectedResult: {kind: "UnacceptableUploadError", error: "For some reason"},
    },
    "when upload is missing": {
      input: {upload: []},
      session: {userId: 42},
      expectedResult: {kind: "UploadMissingError"},
    },
    "when uploaded file is not a JPEG image": {
      input: {upload: [{mimetype: "text/plain", originalname: "", path: "", size: 0}]},
      session: {userId: 42},
      expectedResult: {kind: "BadFileTypeError"},
    },
  }).forEach(([description, {input, session, expectedResult}]) => {
    context(description, () => {
      it("reports the failure", async () => {
        expect(await AvatarUpload(input, session)).to.deep.equal(expectedResult);
      });
    });
  });
});
```

I like this approach makes the tests both clear, and easy to maintain.

Happy testing!
