---
layout: post
title: Jekyll post alias
date: 2018-04-11 10:06
excerpt_separator: <!-- excerpt -->
tags: [jekyll]
categories: []
---

I’ve launched a [new Jekyll website
recently](https://github.com/gurdiga/educatie.pentru.md/tree/fae7c5750264e42c9f8d2d9ee37b8c9bb5827b3f),
and one thing that I wanted to be able to do on the very first days is to be
able to have different URLs for a single post. 🤔

Use-case: I’ve published an article on the blog, but the topic is one that comes
up frequently enough that I want to have it on the FAQ page, but also have
a simple one- or two-word permalink that I would be able to tell someone on the
phone, for example `/socializare`.

<!-- excerpt -->

I wanted something that’s based on the post’s file base-name — which seems to be
the internal post’s identifier — so that it remains maintainable: I want to be
able to grep a post’s name when I decide to change or delete it. It also has to
be [supported](https://pages.github.com/versions/) by GitHub’s build process. (I
know I can generate the files on my machine, and upload them prebuilt, but, for
potential non-tech authors, I wanted to keep the ability to just edit a Markdown
file in GitHub web interface.)

The somewhat standard
[`jekyll/jekyll-redirect-from`](https://github.com/jekyll/jekyll-redirect-from)
didn’t fit because it bases the post associations on the final generated path,
not the post name.

The posts get their permalink generated based on their date and other meta-data,
so I need to create a page file to be able to specify the permalink that I want.
Then I need to specify the post name to alias.

So this is what an
[alias-page](https://raw.githubusercontent.com/gurdiga/educatie.pentru.md/26c938530da4c71d799dc78b9865b53588e02f17/pages/aliases/educatie-alternativa.md)
looks like:

```
---
layout: alias
permalink: two-words
for_post: 2018-04-07-the-post-name
---
```

Naturally it should not have any content of its own.

Then my “custom” [`alias`
layout](https://github.com/gurdiga/educatie.pentru.md/blob/fae7c57/_layouts/alias.html)
needs to find the post by the name given in `for_post` in the `site.posts`
collection, and display it. The post’s name itself [seems not to be
exposed](https://jekyllrb.com/docs/variables/), but exposes its file’s relative
path in the repo, which is close enough and I can compute given the post name:

```
{% raw %}
{%- assign post_path = "_posts/" | append: page.for_post | append: ".md" -%}
{{ site.posts | where: "path", post_path | first }}
{% endraw %}
```

It turns out that having a [Liquid](https://jekyllrb.com/docs/templates/)
expression like this: `{{ post }}` — is all the code that’s needed to render the
post. ✨ Done. 🤓

\* * *

PS: Going a little bit meta… While writing this I realized that in this context
I was somewhat technically shallow, and felt a little nag in the back of my
mind. But thinking a bit more about this, I think it’s because I assumed
a different posture: not of a Developer, but rather of a Tech Guys that can get
things going to enable other people to do their thing.

I wanted to stay focused on getting things working rather than get into Jekyll’s
inner workings and finding The Perfect Solution® — which I think the appropriate
attitude in the context. Cool. 😎
