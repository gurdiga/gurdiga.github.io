---
layout: post
title: Simpler architecture
date: 2020-01-31 09:01 +0200
tags: []
categories: []
---

On the side-project that [I’ve mentioned before][1], I’m making a priority of 2 things: (1) use the least amount of libraries and frameworks, and (2) organize the code in a way that reflects the logical structure of the app.

## Things that I like

On the backend I use Express.js for HTTP, with a [very thin adapter][2] that plugs it into the app. It’s not a RESTful API, it’s more like an [RPC][3]: The backend is a single endpoint listening for POSTs on `/` and receives 2 pieces of data: the scenario name and the scenario [DTO][4] which is the input for the scenario. Having such a small API surface keeps the app logic very neatly separated from the technicalities of HTTP, and as a result allows me to run the app [from the command line][4a] if I later want to run it as a worker, and also makes it simpler to unit test because it’s not entangled with HTTP.

[1]: {% post_url 2020-01-13-typescript-on-backend-and-frontend %}
[2]: https://github.com/gurdiga/repetitor.tsx/blob/49fe24a/backend/src/Utils/ExpressAdapter.ts
[3]: https://en.wikipedia.org/wiki/Remote_procedure_call
[4]: https://en.wikipedia.org/wiki/Data_transfer_object
[4a]: https://github.com/gurdiga/repetitor.tsx/blob/master/backend/src/cli.ts

When thinking about the code organization, I’m trying to find a way that would easily answer the question: “What does this app do?”. One way that I have found to make sense is to use the concept of _scenarios_ (also known as _use-cases_, _user stories_, and _jobs to be done_), so they reflect the activities that the app users will want to do. I have put that code in the [`shared`][5c] module because I will need that knowledge on both, frontend and backend sides. For every scenario, there will be a [_scenario handler_][5b] on the backend, and a [_page_][5a] on the frontend.

The business details like [model][5d] validation will also live in the `shared` module because I’m using them too on both sides: in the browser to validate the forms before submitting them, and on the backend to ensure the data integrity.

I haven’t quite settled on how to do write the validation code. For now, it’s robust but not as elegant as I thin it could be. I’m still keeping an eye on opportunities ([_railway_][5e] seems interesting, but I haven’t tried it yet on this project).

For persistence, I decided to try to get away without an ORM for now: I’m using a [very thin layer][5] that gives me a MySQL connection which allows me to do 2 things: (1) run prepared SQL statements, and (2) give me back the rows. Will review this decision later.

[5]: https://github.com/gurdiga/repetitor.tsx/blob/49fe24a/backend/src/Utils/Db.ts
[5a]: https://github.com/gurdiga/repetitor.tsx/tree/12921f5/frontend/pages
[5b]: https://github.com/gurdiga/repetitor.tsx/tree/9b7d4ad/backend/src/ScenarioHandlers
[5c]: https://github.com/gurdiga/repetitor.tsx/tree/12921f5/shared
[5d]: https://github.com/gurdiga/repetitor.tsx/tree/a12026a/shared/src/Model
[5e]: https://fsharpforfunandprofit.com/posts/recipe-part2/

## Things to improve

At this time I have two levels of code sharing:

1. between the frontend and the backend — where I have the scenarios and the models;

2. between pages on the frontend — where I have components that are shared across pages.

The sharing pages is not perfect yet in terms of bundling: at this point, I bundle everything needed for a page in one bundle, which works, but the drawback is that I have the [same shared code][6a] in multiple bundles which is (1) more bytes sent to the user, and (2) also takes longer to build during development. So there is an improvement opportunity there too.

One other area where I want to improve is the bundling: page bundles end up containing a considerable amount of shared code that they don’t actually use. So I’ll need a “tree-shaking” mechanism, preferably without bringing in an entire build pipeline for that.

### So,

Generally speaking, I’m intentionally making an effort to [balance][6] the tech work with the user-feature work, which means that I will not do work on improving the purely technical aspects at the expense of user features, because otherwise I would end up with a neat but useless system.

Good luck!

[6]: {% post_url 2020-01-25-planning-tip-p-pc-balance %}
[6a]: https://github.com/gurdiga/repetitor.tsx/blob/ada94be/frontend/pages/inregistrare/tsconfig.json#L4-L8
