---
layout: post
title: Input for vim abbrevs
date: '2015-07-12T17:16:07+03:00'
tags: [vim]
categories: []
---
I got into React.js lately, and one thing that I have noticed right away
is the boilerplate that I have to type for every component. For example,
if I have a `Button` component, I have to type this:

```js
var Button = React.createClass({
  render: function() {
    return (
      // here is where I write my code
    );
  };
});

module.exports = Button;
```

Then I realized that I can automate that with a vim abbreviation. They
are pretty useful: you tell vim that when you type a specific keyword,
it should replace that keyword with some other text. For example:

```
iabbrev colo console.log();
```

`iabbrev` stands for “insert mode abbreviation” and vim reads this
command as: when I type “colo” replace it with “console.log();”.

Cool. But as I look at my initial task here I see that I need to somehow
pass it input — the component name: “Button.” Here is where it’s a good
time to tell that the expanded text — the one that replaces the original
keyword — can be more than just text: it can be keys too — for example
`<Enter>` or `<Tab>` — and vim will literally “press” those keys.

How does that help me with the pass-input-to-iabbrev problem? I’m glad
you asked: I can type the component name first, and then the keyword.
For example, if “reco” is my keyword I can say: “Button reco”, then in
the expanded text I can tell vim to jump back, read that component name
and fill it in where needed in the expanded text. Something like this:

```
iabbrev reco <Esc>B"zde"_xi
```

This is exactly what I would do manually:

* `<Esc>` to switch from insert mode to command mode
* `B` to jump back one
	[WORD](http://vimdoc.sourceforge.net/htmldoc/motion.html#WORD) — so
	the cursor is now at the beginning of my component name
* `"zde` to cut the component name into the `z` [named
	register](http://vimcasts.org/episodes/using-vims-named-registers/) so
	that I can paste it later where needed
* `"_x` to delete the space between the component name and the reco
	keyword
* `i` — “insert” — switch back to insert mode

Now I have the component name stored handy, so I can tell vim type in
the boilerplate code. But to keep the whole thing tidy, I will put the
expanded text on the next line:

```
iabbrev reco <Esc>B"zde"_xi
\var "zpa = React.createClass({
```

The backslash at the beginning of the line tells vim that it’s actually a continuation of the previous one. So, what I tell vim to do on the second line is:

* type “var ”
* `<Esc>` switch to command mode
* `"zp` paste the text in the z register — the component name
* `a` — “add” — switch back to input mode and put the cursor after the
	current position
* type “ = React.createClass({”

OK. Looks good. Next, I want vim to hit <Enter>, <Tab> to indent, and
then type “render: function() {”. When my expanded text is more than one
line, I like to have each line as a separate line in the iabbrev command
too. Here is how it looks so far:

```
iabbrev reco <Esc>B"zde"_xi
\var "zpa = React.createClass({<Enter>
\<Tab>render: function() {<Enter>
```

Looks good, and reads reasonably well. OK, next I’d hit `<Enter>`,
`<Tab>` to indent, type “return (” and hit `<Enter>` again, then type
“);” and hit `<Enter>` one more time. So:

```
\<Tab>render: function() {<Enter>
\<Tab>return (<Enter>
\);<Enter>
```

Now I need to unindent. I usually do that hitting `<Backspace>` twice —
I use 2-space indentation — but here I want this script to work no
matter how I indent, so I will use `<Control>+D` which does exactly
that: unindent one level considering the current [intentation
options](http://vim.wikia.com/wiki/Indenting_source_code) no mater what
they are. So, I only need to unindent, close the bracket from the
`render` function and hit `<Enter>`:

```
\<C-D>}<Enter>
```

Then, one more unindent, close the round and curly brackets from the
React.createClass call at the beginning:

```
\<C-D>});<Enter>
```

OK, now I need an empty line and the export statement:

```
\<Enter>
\module.exports =
```

Oh, but here I need the component name again. So I need to:

* switch to command mode with `<Esc>`
* press `"zp` to paste the component name from the register
* switch back to insert mode with the `a` command
* type “;”

OK, so:

```
\module.exports = <Esc>"zpa;
```

OK. But now it would be nice to jump back to the place where I actually
type my code: between the `return`’s brackets in the `render` function.
No problem:

* switch to command mode with `<Esc>`
* type “?” to enter the search mode, type “return” and hit `<Enter>` to
	trigger the search and move to that word
* now the cursor is at the beginning of the `return` and — because I’m
	still in the command mode — I hit o to enter a new line below the
	current one
* hit `<Tab>` to indent

So:

```
\<Esc>?return<Enter>o<Tab>
```

Nice. There is a little thing though: when I typed the keyword, I have
also typed a space after it — naturally. So vim keeps that space and
puts it after the expanded text. I don’t need it here so I will quickly
switch to the command mode, delete it, and switch back to input mode as
if nothing happened:

```
\<Esc>"_xa
```

OK, so here is all the code:

```
iabbrev reco <Esc>B"zde"_xi
\var <Esc>"zpa = React.createClass({<Enter>
\<Tab>render: function() {<Enter>
\<Tab>return (<Enter>
\);<Enter>
\<C-D>}<Enter>
\<C-D>});<Enter>
\<Enter>
\module.exports = <Esc>"zpa;
\<Esc>?return<Enter>o<Tab>
\<Esc>"_xa
```

That’s it! Now I put this in `~/.vim/ftplugin/jsx.vim` and instead of
typing all the text above at the top, I just type “Button reco” and vim
does all the rest.

It probably looks more criptic compared to the “snippet” functionality
in other editors, but it’s also more powerful and more flexible.
