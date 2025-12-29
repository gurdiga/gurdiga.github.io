---
layout: post
title: Markdown lists with vim
date: 2018-03-28 20:29
tags: [vim, markdown, tools, productivity]
---

The other day I found myself copy-pasting some Google Docs texts into [a new
Jekyll website](https://educatie.pentru.md), and so I had to format quite
a bunch of lists. After Google Docs, the reflex was to select the rows, and hit
`⌘+Shift+8`, so I thought: Hey why not make a key-mapping? 🤓

I’ve tried this kind of thing
[before](https://github.com/gurdiga/dotfiles/commit/90c0177ef26cebed7a958ce0681089ad1f1423e1)
and I new it’s hard to get the `⌘+Shift-` key mappings, so I went with what I knew
worked, so I decided on `Alt-8` instead.

Here is what came out:

```
vnoremap <buffer> ¶ :s/^\s*/\0* /g\|:nohlsearch<CR>
```

So it’s a visual map: it’ll work on a selection of lines. I know some Vim
veterans disregard visual mode as not hard-core enough, and recommend using text
objects instead, but visual mode seems to work quite well for me so far. 😉

It’s a [`<buffer>`
mapping](http://vimdoc.sourceforge.net/htmldoc/map.html#:map-%3Cbuffer%3E), so
that it’s only set for the current buffer, and it can do something else in
buffers of other types.

It’a `noremap` just to be safe: if any of the mapped key-strokes are mapped to
something else by some other module, I don’t want them to interfere.

The `¶` thingy is what comes out when you type `Alt-7` on a Mac. `¯_ツ_¯`

Of course (!) one can’t figure out the bulleted lists without also thinking
about the numbered ones, so I though `Alt-8` would be a perfectly natural next
step. 🙂

Here it comes:

```
vnoremap <buffer> • :s/^\s*/\00 /g\|:nohlsearch\|:normal gpo^g<CR>
```

[Neat!](https://github.com/gurdiga/dotfiles/commit/eadfa45306d233f269d130c5f0b13d08bbcf5205) 🤓

\* * *

P.S.: As is often the case, writing this quick article exposed a glitch in the
last key-binding, and [a
hole](https://github.com/gurdiga/dotfiles/commit/a79e24e2dbb01337f1cdcb59b58b02110882e659)
in my understanding of how this whole thing works: I thought I needed <span
style="white-space: nowrap">`<C-U>`</span> at the beginning, and while checking
again the docs I found I actually don’t. Cool! 🤓
