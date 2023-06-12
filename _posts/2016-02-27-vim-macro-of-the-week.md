---
layout: post
title: Vim macro of the week
date: '2016-02-27T16:51:23+02:00'
tags: [vim]
categories: []
---
The other day I was putting together an ad-hock `eslint` configuration
where I had just one JS file for a prototype page. I was inside a git
repo and I didn’t want to have additional files, so I kind of resisted
the idea to have a `.eslintrc` file, but I can have a `Makefile` — I
have that in my `~/.gitignore`, so I can easily add one here and have
all the messy bits hidden inside it:

```make
default: lint

lint:
    eslint checkout.js
```

So now I can say `make` or `m` and have my JS file linted. Cool, but how
do I add `eslint` rules? It turnes out that it
[allows](http://eslint.org/docs/user-guide/command-line-interface) me
make all the configuration I want by passing arguments, so to add one
rule at a time by passing them as separate `--rule` arguments:

```
eslint \
  --rule 'comma-dangle: [2, "never"]' \
  --rule 'no-cond-assign: 2' \
  ...
  checkout.js
```

Messy, but good enough for this context. After typing in 5 of those
lines of `--rule 'something'` I was wondering how can I automate this. A
vim macro was the first thing that came to mind so being on such a line,
I wanted to copy-paste it, and then change the thing inside the quotes
to whatever I have just copied from the
[rules page](http://eslint.org/docs/rules/).

So I started with this:

* `qq` — start recording a macro named q
* `yyp` — duplicate the line
* `ci'` — delete what’s inside the quotes and switch to insert mode
* hit `Command-V` to paste whatever I had in the OS clipboard
* hit `Esc` to return to command mode and prepare for the next iteration
* `q` to finish the recording

Now to use it:

* copy another rule into OS clipboard
* switch to vim and hit `@q` to run the q macro that I just recorded

Nope. The `^V` was taken by vim literally: to just type in the
characters that I `then` had in the OS clipboard. So, to make it work, I
had to explicitly tell vim “paste the contents of the OS clipboard here”
which in its lingo is `^R+` — this while in insert mode. So I
re-recorded the macro as above and just replaced `^V` with `^R+`:

```
qqyypci'^R+<esc>q
```

That worked! Now I can: switch to browser, copy, and the just switch to
vim and hit `@@` to have another rule added. 8-)
