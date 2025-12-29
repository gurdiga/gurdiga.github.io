---
layout: post
title: 'bind: warning: line editing not enabled'
date: 2018-04-14 15:55 +0300
tags: [bash, make, debugging, tools]
---

The other day I was writing a Makefile which involved
[`nvm`](https://github.com/creationix/nvm/) and stumbled upon an error that
seemed to make sense, on one hand, but on the other hand I couldn’t quickly
google out a clean solution. Digging in some more, I’ve devised my own, which
I’m going to present here. 🤓

As I’ve mentioned before, for every new project that I get on, as part of the
onboarding I write a Makefile for the stuff I’ll need to run frequently, so that
I can make use my muscle memory instead of trying to brute-forcefully remember
them.

So I needed to run something like `nvm exec 9.11.1 yarn test`, which is tricky
because `nvm` is implemented [as a shell
function](https://github.com/creationix/nvm/blob/b15709e/nvm.sh#L2269) which is
defined when a login shell is initialized, and so can’t directly be called from
a script. One way to get that is this:

```make
test:
	bash --login -c 'nvm exec 9.11.1 yarn test'
```

And it worked, except that there was a warning that pointed to
a [line](https://github.com/gurdiga/dotfiles/blob/f2097a83b7e33671abd8318944d23157de07a129/.bashrc.my#L272)
in `~/.bashrc.my` where I was defining a custom Bash key-binding with
[`bind`](https://www.gnu.org/software/bash/manual/html_node/Bindable-Readline-Commands.html#Bindable-Readline-Commands):

```
/Users/vlad/.bashrc.my: line 277: bind: warning: line editing not enabled
```

OK, makes sense: this is not a real login shell, and because of that `bind`
complains. There should be a way to detect that and skip `bind` calls in that
case. After a few sporadic rounds of disappointing “let’s google this quickly”,
I went to [The
Source®](https://www.gnu.org/software/bash/manual/html_node/index.html) with the
intention to find out The Right Way® to do this.

Essentially I needed to write a `is_interactive_shell` function, and although
the implementation [is not exactly
straightforward](https://www.gnu.org/software/bash/manual/html_node/Is-this-Shell-Interactive_003f.html),
it’s still much nicer than what I’ve been able to find so far:

```bash
function is_interactive_shell() {
	# https://www.gnu.org/software/bash/manual/html_node/Is-this-Shell-Interactive_003f.html
	[[ "$-" =~ "i" ]]
}
```

...and now I can say:

```
if is_interactive_shell; then
	# fzf git branch name; use like this: git checkout ^g^b
	bind '"\C-g\C-b": "$(git branch -a | cut -c 3- | fzf)\e\C-e"'
fi
```

Nice and clear! 👍

\* * *

PS: I later found out that I could get away with something like this:

```
source ~/.nvm/nvm.sh && nvm exec ...
```

...which would have prevented the warning altogether, 😆 but it’s still useful
to understand the warning and how to work around it. 🤓
