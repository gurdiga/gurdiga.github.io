---
layout: post
title: 'Simpler architecture: specifics'
date: 2020-02-14 08:40 +0200
tags: [typescript, architecture, side-projects, web]
---

Two weeks ago [I wrote][1] about the overall organization of the code on [my side-project][2]. I have since then added a couple more scenarios, and I want to get just a little bit into the specifics of it.

[1]: {% post_url 2020-01-31-simpler-architecture %}
[2]: https://github.com/gurdiga/repetitor.tsx/

I think about the functionality of the system as user scenarios: specific workflows that users would go through to achieve something of value to them. For example the “Tutor Registration” scenario contains the code related to tutor registration (Yeah!!). For a web app, when it’s deployed, some of this functionality exists on the front-end, and some on the back-end, specifically:

1. A page on the front-end.
2. A scenario handler on the back-end.

I will get into more details on both of them, and some more.

## 1. A page on the front-end

This is where the UI for the interaction lives. For this specific scenario, it’s [a separate page][2a], but I guess that for some scenarios I’ll not need a whole new page, it can be a form, or a section, or a modal that can contain all the UI elements needed.

[2a]: https://github.com/gurdiga/repetitor.tsx/tree/c0a9a59/frontend/pages/inregistrare

I have pages implemented as separate [TypeScript modules][3], and the React code for each of them ends up bundled as an [AMD][4] module which gets loaded from the HTML template. The AMD is not a particularly [modern][5] module format, but I’m using it because the TypeScript compiler supports it out-of-the-box, and because It Works™.

[3]: https://www.typescriptlang.org/docs/handbook/project-references.html
[4]: https://en.wikipedia.org/wiki/Asynchronous_module_definition
[5]: http://boringtechnology.club/

If you’re asking where the CSS code goes, I’m glad you asked: it’s also bundled into the AMD module, together with the React code. I decided I’m going to use a CSS-in-JS approach with [`TypeStyle`][6]. This subject is worth a post on its own, so I’m not going to go into a lot of details today.

[6]: https://github.com/typestyle/typestyle#typestyle

In short, all of the application UI HTML and CSS code ends up as a single JS file. The vendor modules [come from NPM][7].

[7]: https://github.com/gurdiga/repetitor.tsx/blob/fd13183/frontend/package.json#L12-L19

## 2. A scenario handler on the back-end

On the front-end, I collect all of the user input relevant to a scenario into a data transfer object ([DTO][8]), and [submit][9] it to a scenario handler on the backend.

[8]: https://en.wikipedia.org/wiki/Data_transfer_object
[9]: https://github.com/gurdiga/repetitor.tsx/blob/2629737/frontend/shared/src/ScenarioRunner.ts#L3-L6

I mentioned before that I have a [thin integration layer][10] — the scenario runner — between the ExpressJS app server, and my scenario handlers which only [validates][11] the scenario name and passes it the DTO, and sometimes the session object if necessary. It can be thought of as the routing layer in a more conventional web app.

[10]: https://github.com/gurdiga/repetitor.tsx/blob/a19c286/backend/src/Utils/Express/Adapter.ts
[11]: https://github.com/gurdiga/repetitor.tsx/blob/4b5578e/backend/src/Utils/ScenarioRunner.ts#L21

The [scenario handler][12] is a function that receives its DTO, validates it, and invokes the necessary persistence code, and returns the response to the scenario runner which then passes it back to Express as the HTTP response.

[12]: https://github.com/gurdiga/repetitor.tsx/blob/c0a9a59/backend/src/ScenarioHandlers/TutorRegistration.ts

## 3. The secret sauce

Yes, I know that I initially only mentioned 2 parts: the back-end and the front-end, but there is actually a third, a glue-of-a-sorts part, that ties the first two together: the [`shared/`][13] module. It contains the pieces of code that are common between front-end and back-end: [data types][14] and [logic][15] that is, on one hand, reused between the two, but more importantly, it ties the two sides together such that if I add a field to the scenario DTO, the compiler can point out all the places that I need to update, _on both sides_. This means significantly less effort than I would have had on a pure JS codebase.

[13]: https://github.com/gurdiga/repetitor.tsx/tree/c0a9a59/shared
[14]: https://github.com/gurdiga/repetitor.tsx/blob/c0a9a59/shared/src/Scenarios/TutorRegistration.ts
[15]: https://github.com/gurdiga/repetitor.tsx/blob/c0a9a59/shared/src/Model/Tutor.ts

This glue, I think, is the secret sauce, one of the most valuable technical aspects of TypeScript that I wanted to make good use of, and which I’m glad I got in place.

