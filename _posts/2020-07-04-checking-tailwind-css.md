---
layout: post
title: Checking Tailwind CSS
date: 2020-07-04 16:28 +0300
tags: [css, web, tools, side-projects]
---

One of the things on [my side project][0] that I felt iffy for some time is the UI toolkit. I have gathered notes, links, fonts, but I have held back from actually trying anything so far. I wanted to first have a robust setup that would allow me to add functionality, frontend and backend. Having that more or less in place, the goal that I had set for this sprint was to look for a UI toolkit. I have recently heard about Tailwind CSS on [“The Art of Product” podcast][1] and I made a note to take a look at it.

[0]: https://github.com/gurdiga/repetitor.tsx
[1]: https://artofproductpodcast.com/

This is my first contact with a “functional CSS” library. I have stumbled upon the concept a couple of times, I think it was [Tachyons][2a], but it didn’t appeal enough to dive deeper. So before I try it I wanted to first see how is it _properly_ done, so I went through a couple of [screencasts][2] on their website. The first impression was “Wow! Pretty smooth.” So for the next couple of morning I went through all of the lessons.

[2a]: https://tachyons.io/
[2]: https://tailwindcss.com/screencasts/

After that I went through their [docs][3], and tried to imagine how would I fit it within the project. I like the idea to have a single CSS file—The Library®—for the whole website, and not have custom CSS files. I can, but I don’t have to write custom CSS files, and this feels super releaving after years of “classical” frontend development, where I have CSS files, and I have the other code referencing classes in it, and slowly but surely the CSS files would grow into a hairy and unmaintainable mess that is giving me shivers…

[3]: https://tailwindcss.com/docs/

So my idea is to have the styling and layout done with utility classes only, and not have any custom CSS files at all. I will disconsider the performance implications of that for now, and only focus on maintainability.

I also like that it gives me the option to not have CSS processing/compilation part of my development cycle. I have the base CSS file compiled from [their NPM package][4], and from then on I only juggle the classes in my React code.

[4]: https://www.npmjs.com/package/tailwindcss

Other notable thing that I liked is the support for theme configuration, integration with PostCSS and PurgeCSS, and the intellisense plugin for VSCode. I love how they try to give a nice development experience.

Overall, the screencasts, the docs, and everything else around Tailwind CSS left me with the impression that They Know What They’re Doing®. As a bonus, the community seems good too. A quick googling gave me [TailwindComponents.com][5] and [TailwindToolbox.com][6] which are both free, and there is also their commercial offering [TailwindUI.com][7] which I am very tempted to try.

[5]: https://tailwindcomponents.com/
[6]: https://www.tailwindtoolbox.com/
[7]: https://tailwindui.com/

I have already created a Git branch, began wiring everything up, and I’m excited to see what can I do with it. I’ll post more updates as I learn.
