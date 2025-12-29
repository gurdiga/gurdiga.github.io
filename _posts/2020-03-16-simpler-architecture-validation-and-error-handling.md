---
layout: post
title: 'Simpler architecture: validation and error handling'
date: 2020-03-16 20:45 +0200
tags: []
---

Today I would like to explain how I arrange validation and error handling on my [side project][1]. One useful outcome of using TypeScript on both sides — backend and frontend — is that I get to share the data structures, error states, and also the validation logic. And it’s not as much about sharing the code itself, but about **the ability to keep the two sides aligned as the code evolves**.

[1]: https://github.com/gurdiga/repetitor.tsx

As I mentioned in [a previous post][2], the shared parts of the code live in [`shared/`][3] module. It divided in 3 major parts now: scenarios, model, and utils.

[2]: https://gurdiga.com/blog/2020/02/14/simpler-architecture-specifics/
[3]: https://github.com/gurdiga/repetitor.tsx/tree/f610ad3/shared/src

A _scenario_ is an abstraction that represents a discrete user interaction, and defines the input and the possible results of this interaction. Here is an example: `TutorPasswordResetStep2` is the second part of the password reset process, specifically, after the user receives the email with a magic link in it, clicks the link, lands back in the app and submits the form with the new password:

```ts
// shared/src/Scenarios/TutorPasswordResetStep2.ts

export interface TutorPasswordResetStep2Input {
  token: string | undefined;
  newPassword: string | undefined;
}

export type TutorPasswordResetStep2Result =
  | TutorPasswordResetSuccess
  | PasswordResetTokenError
  | PasswordResetTokenUnknownError
  | PasswordError
  | SystemError;
```

So I literally have 2 types: one for the _input_ and one for the possible _results_. For the input, I assume that every attribute is potentially `undefined` because it’s user input.

The result type, is a union type of all of the possible outcomes of carrying out the scenario, so in this case, I begin with the happy path — `TutorPasswordResetSuccess` — it’s an empty interface that signals that all went well. The `PasswordResetTokenError` is another interface that signals the situation that there was an issue with the _structural_ validation of the reset token.

The structural validation is comprised of all the checks I can do for a piece of data before hitting the DB. For the reset token, in particular, there is little you can do besides checking for presence, but for other domain values, I can have more things I can check. A more interesting example is the user’s full name: it can be missing, it can be present but too short, or it can be too long. I like to have these nuances identified so that I can show a clearer validation message to the user, and so the type has a field to capture that nuance called `errorCode`. Here is how the structural part of the validation types would look like:

```ts
// shared/src/Model/Tutor.ts

type FullNameError = {
  kind: "FullNameError";
  errorCode: FullNameValidationErrorCode;
};

export type FullNameValidationErrorCode = "REQUIRED" | "TOO_SHORT" | "TOO_LONG";
```

For the initial scenario mentioned above, I have one structural validation error type for each input attribute, so `PasswordResetTokenError` and `PasswordError`. Besides those, I also have an error state related to the larger domain validation that I can’t do by only looking at the value. In the case of a password reset token, it can happen that it’s not found: `PasswordResetTokenUnknownError`, which is an empty interface since there is no other relevant information to communicate.

Besides these more or less application-related error states, I leave room for system errors: `SystemError`. This is a union type itself:

```ts
// shared/src/Model/Utils.ts

export type SystemError = DbError | UnexpectedError;

export type DbError = {
  kind: "DbError";
  errorCode: DbErrorCode;
};

export type DbErrorCode = "GENERIC_DB_ERROR";

export type UnexpectedError = {
  kind: "UnexpectedError";
  error: string;
};
```

So it covers DB errors, and “other” errors.

OK, that’s about all of the possible results that I could think of in this scenario. So besides all these types, the model also contains the _factory function_, which does the structural validation of the input and either returns a valid request for scenario execution if the input is valid — `TutorPasswordResetStep2Request` — or, returns a value signaling the validation error — `PasswordResetTokenError` or `PasswordError`. Its body looks a bit boilerplaty, but it’s clear and maintainable:

```ts
// shared/src/Model/TutorPasswordResetStep2.ts

export function makeTutorPasswordResetStep2RequestFromInput(
  input: TutorPasswordResetStep2Input
): TutorPasswordResetStep2Request | PasswordResetTokenError | PasswordError {
  const {token, newPassword} = input;
  const tokenValidationResult = validateWithRules(token, PasswordResetTokenValidationRules);

  if (tokenValidationResult.kind === "Invalid") {
    return {
      kind: "PasswordResetTokenError",
      errorCode: tokenValidationResult.validationErrorCode,
    };
  }

  const newPasswordValidationResult = validateWithRules(newPassword, UserPasswordValidationRules);

  if (newPasswordValidationResult.kind === "Invalid") {
    return {
      kind: "PasswordError",
      errorCode: newPasswordValidationResult.validationErrorCode,
    };
  }

  return {
    kind: "TutorPasswordResetStep2Request",
    token: tokenValidationResult.value,
    newPassword: newPasswordValidationResult.value,
  };
}
```

This factory function will be called from the _scenario handler_ in the backend:

```ts
// backend/src/ScenarioHandlers/TutorPasswordResetStep2.ts

type Scenario = ScenarioRegistry["TutorPasswordResetStep2"];

export async function TutorPasswordResetStep2(input: Scenario["Input"]): Promise<Scenario["Result"]> {
  const inputValidationResult = makeTutorPasswordResetStep2RequestFromInput(input);

  if (inputValidationResult.kind !== "TutorPasswordResetStep2Request") {
    return inputValidationResult;
  }

  const {token, newPassword} = inputValidationResult;
  const storablePassword = getStorablePassword(newPassword);

  return await resetTutorPassword(token, storablePassword);
}
```

Unless the model factory function tells that the input is valid, its result is returned from the scenario handler back to the client. One useful thing about  sharing the types with the client is that they are kept in sync, so the client will be able to properly handle whatever comes out of the backend.

So, when the input is proven to be valid, the scenario handler will call the relevant persistence and other platform code. In this particular case, I will need to compute the salted hash for the new password, which will be passed to the persistence code.

The persistence code works in a similar manner: it gets the valid input and returns one of a series of possible outcomes: `TutorPasswordResetSuccess`, `PasswordResetTokenUnknownError`, or `DbError`.

```ts
export async function resetTutorPassword(
  token: string,
  storablePassword: StorablePassword
): Promise<TutorPasswordResetSuccess | PasswordResetTokenUnknownError | DbError> {
  const tokenVerificationResult = await verifyToken(token);

  if (tokenVerificationResult.kind !== "PasswordResetTokenVerified") {
    return tokenVerificationResult;
  }

  await deleteToken(token);

  const {userId} = tokenVerificationResult;

  return await resetPassword(userId, storablePassword);
}
```

The [`verifyToken`][5], [`deleteToken`][6], and [`resetPassword`][7] helper functions look very similar in structure: they run SQL queries and return a data structure, that either reports the success or failure, as specific as necessary in the context.

[5]: https://github.com/gurdiga/repetitor.tsx/blob/8e226971ea383528b3aa97ca078603a1b7e9c6cc/backend/src/Persistence/TutorPersistence.ts#L165-L193
[6]: https://github.com/gurdiga/repetitor.tsx/blob/8e226971ea383528b3aa97ca078603a1b7e9c6cc/backend/src/Persistence/TutorPersistence.ts#L214-L228
[7]: https://github.com/gurdiga/repetitor.tsx/blob/8e226971ea383528b3aa97ca078603a1b7e9c6cc/backend/src/Persistence/TutorPersistence.ts#L214-L228

To keep this post from growing even longer, I have left out many details, but you can browse [the code on GitHub][4] and see how it all fits together.

[4]: https://github.com/gurdiga/repetitor.tsx/tree/8e226971ea383528b3aa97ca078603a1b7e9c6cc
