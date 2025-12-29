---
layout: post
title: Angular 6 years later
date: 2020-08-08 18:36 +0300
tags: []
---

In 2014, [I wrote about][1] a couple of things that I liked about Angular, then at v1.4, I think. Now, as I’m getting on Angular at my new job, and I’d like to share the things I like again. So far, the concepts seem familiar, and I will only comment on the things that jump at me, from the perspective of a newcomer.

[1]: {% post_url 2014-04-03-my-3-why-angulars %}

I’m going through their tutorial where you go from zero to a small project where you’d touch most of the Angular concepts. I’m not finished with it yet, but I already have a few things that I like.

## 1. TypeScript

After the 4 years at Mixbook, I went from no-TypeScript to love-TypeScript. Any non-trivial JS code that I want to write, I’d consider writing in TS. Having Typescript in Angular is a huge thing for me, as a newcomer on the project: with a TS-capable editor or IDE, it makes the project almost instantly inspectable, and it also reduces a ton of anxiety that I would have on a JS project of a comparable complexity.

## 2. Scoped CSS

This is another non-trivial thing that any frontend engineer would appreciate: every component can have their own CSS that doesn’t spill-over into other components. I also liked the trick they employed to implement this scoping: they add a custom empty attribute to the component root, for example `_ngcontent-lyu-c41`, and then they inject it as a selector to the component’s CSS rules:

```css
/* in the code */
.heroes li {}

/* in the browser */
.heroes[_ngcontent-lyu-c41] li[_ngcontent-lyu-c41] {}
```

## 3. Generators

The [`ng generate`][2] suite of commands makes me feel welcome. I like that besides generating the needed source files, I also get the test files with the necessary boilerplate. What surprised me the most though, is that the newly generated thing—the component or service or whatever—is plugged into the app component _in the code_.

[2]: https://angular.io/cli/generate

## 4. A pre-determined place to put things

While this is not specific to Angular, it’s still useful thing to have, especially when you join an existing project: you know where to find existing things and you know where to put new things.

\* * *

That’s it so far. I know there is more to come. While the larger-picture concepts are still familiar from the Angular that was 6 years ago, like components, directives, services, and dependency injection, there are things that are new, like routing and the CLI.

This week I’m going to go full-contact into an existing project, so I expect to have more findings to report in the next post.

Happy coding.
