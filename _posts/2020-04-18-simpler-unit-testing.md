---
layout: post
title: Simpler unit testing
date: 2020-04-18 10:49 +0300
tags: []
categories: []
---

The other day while browsing through [my side-project’s code][1] I realized that I don’t have unit tests for the shared modules.

[1]: https://github.com/gurdiga/repetitor.tsx/

As this realization dawned on me, it first caused a worry similar to that when you realize you didn’t lock the door when you left the house, but as I thought more about it I realized that this is actually a good thing: on one hand all this code is tested _indirectly_ by the the backend and frontend unit tests, and on the other hand, not having tests for it allows it more flexibility.

By flexibility here I mean that I can refactor it without the need to change a lof of unit tests. This is an interesting idea if you look from the perspective of the definition of refactoring:

> Code refactoring is the process of restructuring existing computer code without changing its external _behavior_.

I mean it makes so much sense: If unit tests are written to test code’s external behavior, then they shouldn’t have to change during refactoring. A little tangent here is that the perspective of breaking a lot of unit tests sometimes can subtly cause resistance to doing refactoring, which is not a Good Thing™.

As I think through this I realize that I haven’t thought about this larger-picture implications when picking what to test, I just wanted to have some unit tests to ensure that my code still works. — It’s going to be interesting to see for how long can I get away with this. It’s not that I don’t want in principle to have unit tests for the shared code, I probably will add unit tests when it would make sense, but it still seems like an intriguing idea.

I remember years ago when I discovered TDD and unit testing as a concept, the tendency was to have a unit test for every little bit of code. A bit extreme, as I guess happens with every good thing discovered, and soon enough I have also discovered the frustration related to having to update the unit tests a lot.

On this side-project when I need to [add][2] new functionality, I begin with defining a [scenario][3] and define its inputs and outputs. These serve as a base and guide the implementation of the associated frontend and backend code. After I have what seems like a working first implementation, when the idea is mostly formed, then I add unit tests. This way I avoid the effort of constant rework of unit tests as the implementation evolves.

[2]: {% post_url 2020-02-14-simpler-architecture-specifics %}
[3]: https://github.com/gurdiga/repetitor.tsx/tree/e066557/shared/src/Scenarios

I think I can afford this because the scenarios are small enough so far. Even more, I can break the work in two pieces: after defining the scenario, I can do the backend first and [its unit tests][4], then do the frontend and [its unit tests][5].

Happy testing! 🙂

[4]: https://github.com/gurdiga/repetitor.tsx/tree/e066557/backend/tests
[5]: https://github.com/gurdiga/repetitor.tsx/tree/a6c909e/frontend/tests
