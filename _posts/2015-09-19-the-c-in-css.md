---
layout: post
title: The “C” in CSS
date: '2015-09-19T19:26:46+03:00'
tags: [css]
---
One of the first things that I learned about CSS is that it cascades.
Cascading is a lot like inheritance in OOP. It’s useful for the same
reasons, and, for the same reasons leads to CSS fragility when misused.

At the beginnings of the Web, when CSS came out, we decided that
presentation code should live separate from the content. It seemed like
a reasonable decision. Pages were a lot like documents back then, and it
was convenient not to set text-indent or font for every paragraph on the
page.

Websites back then were pretty static, and we only used a small subset
of elements, so the little CSS file that covered most pages had a good
ROI. We saved a lot of bandwidth and made the content clearer and easier
to maintain.

These days though, the Web is much more about Web-apps. They have rich
dynamic interfaces. They have much more elements which combine in even
more ways. Even with advanced CSS-specific architectures, it becomes
harder and harder to maintain and grow our CSS.

The thing that contributes most to this is that presentation code lives
separate from the content. Because it lives and grows separate from the
elements it refers, the responsibility to keep them in sync rests with
the front-end developers. And when the CSS grows to thousands of lines
of code, that is too much to ask of humans. That decision that we made
back then, seems to be counterproductive now.

Then React.js. came out. They had the idea to have CSS together with the
rest of component’s code. It felt weird at first. But then I came to
realize that the more I had CSS within my components, the less trouble I
had with it.

A few months ago I started working on a single-page Web-app. I have
started building it with React.js. Then I gave up on React.js and
switched to raw JS. One thing that I kept though is the idea of having
the CSS live with the rest of widget’s code.

Now I realize that event after a few months of coding, I have less than
100 lines in style.css, and I don’t have any trouble caused by CSS. And
maybe CSS doesn’t necessarily have to cascade. It seems to be a lot more
easy to work with when it’s seen as just styling.

\* * *

I initially wanted to entitle this article “There is no CSS” — to draw
the analogy with the “there is no spoon” moment in The Matrix: I had all
this trouble with CSS because I accepted it’s cascading nature,
when “the truth” is that it doesn’t have to be. I just had to change my
perspective on it.
