---
layout: post
title: 'Vim: recursive iabbrev'
date: '2016-04-08T09:00:49+03:00'
tags: [vim]
categories: []
---
*TLDR*: Although
[Vim documentation](http://vimdoc.sourceforge.net/htmldoc/map.html#Abbreviations)
says “Abbreviations are never recursive,” you can get abbreviations to
recurse by escaping to the command mode.

\* * *

When I write specs there is usually a little bit of boilerplate, for example:

```js
describe('some feature', function() {
    // tests go here
});
```

then there are a few similar calls for setup, teardown, and individual
tests, and each of them contains a function expression. And then there
are also quite frequent cases when I need a function expression as a
callback, IIFE, or an iteratee for FP-style chains with `map` and
friends.

Although it can get into muscle memory with time, it’s still a lot of
typing, and to avoid that I
[have](https://github.com/gurdiga/dotfiles/commit/8168f8134e205f69f0f9951c350054f35d543b0c)
set up a few iabbrevs, for example:

```
iabbrev tede describe(', function() {});<esc>F}i<cr><esc>O<tab><up><esc>2f'i
```

this lets me type `tede` and when I press `<space>` I get this:

```js
describe(', function() {

});
```

and the cursor is placed between the quotes in insert mode, so I can
just type the feature description. Neat! 8-)

I will reformat for readability like this:

```
iabbrev tede describe(', function() {});
  \<esc>F}i<cr>
  \<esc>O<tab><up>
  \<esc>2f'i
```

Now, at my day job, the code convention says that in function
expressions we have to have a space before the opening paren. Um… OK: I
have `set exrc` in my `~/.vimrc`, so I can just have a per-project
`.vimrc` that would redefine those iabbrevs, with the space before the
opening paren. OK.

Then a few weeks ago I’ve played a bit with
[Calypso](https://github.com/Automattic/wp-calypso) and their coding
guidelines ask for a space before the opening paren, but also on the
inside of parens, similar to
[jQuery’s](https://contribute.jquery.org/style-guide/js/).

The thought of having yet another .vimrc with all the iabbrevs didn’t
sound right, and knowing that the only difference was the spacing around
parens in function expressions, I thought: I should be able to somehow
extract the iabbrev for function expression, and only have _that_
redefined on a per-project basis.

Googled a bit, and then found a StackOverflow answer mentioning that
Vim’d docs explicitly
[say](http://vimdoc.sourceforge.net/htmldoc/map.html#Abbreviations):

> Abbreviations are never recursive.

Um… OK. But I know that in software *Everything is possible®*, so I went
and re-read the docs section on abbreviations from cover to cover.
Nothing.

Then I realized that I can escape to _normal_ mode in the abbreviation
body by pressing `<Esc>` and from there I can run a _command-line_ mode
command, and from there I can execute a `:normal` command that can
execute another `iabbrev`:

```
 iabbrev xx <esc>:normal a_some_iabbrev<cr>
```

So,

* `<Esc>` switches to normal mode;
* `:` switches to command-line mode;
* `normal` command-line command executes the given normal command, which
	in this case is `a_some_iabbrev` which reads as: enter insert mode,
	and type in `_some_iabbrev`;
* `<CR>` at the end is as we’d press  to execute the command after we
	entered it in the command line.

OK, so now if I have the function expression in a (conventionally)
`private` abbrev like this:

```
iabbrev _fn function() {}
```

I can redefine my earlier `tede` iabbrev like this:

```
iabbrev tede <esc>:normal a_fn<cr>
  \Idescribe(',<space>
  \<esc>A);
  \<esc>F}i<cr>
  \<esc>O<tab><up>
  \<esc>f'a
```

which, first runs `_fn` (which expands to `function() {}`), then types
in the other pieces around it, just as before.

Now, for the projects at work I only need to redefine `_fn` to have the
space before the paren:

```
iabbrev _fn function () {}
```

Neat! 8-)

\* * *

If you get into an infinite loop, Vim errors out when stack size is 200.
For example, here `_ia3` calls `_ia2`, which calls `_ia1`, which closes
the loop calling `_ia3`:

```
iabbrev _ia1 ia1<esc>:normal a_ia2<cr>a
iabbrev _ia2 ia2<esc>:normal a_ia3<cr>a
iabbrev _ia3 ia3<esc>:normal a_ia1<cr>a
```

If you try to run any of these, you’ll get 200 of `ia[123]` typed into
your buffer, after which Vim will stop and throw an error:

```
Error detected while processing InsertEnter Auto commands for "*":
```

So you can’t get too far down the wrong path. :-)

\* * *

It would be really awesome to hear your thoughts on this solution.
Thank you! :)
