---
layout: post
title: Per-directory Bash history
date: 2020-07-18 20:44 +0300
---

I’m a heavy console user and I like my shell history to be relevant to the project that I’m working on. For example if I `cd` into `~/src/mixbook_editors`, I want the shell history for that specific project—this is what I mean by _per-directory Bash history_.

Here is how I have this set up: I am exploiting the `PROMPT_COMMAND` environment variable. This variable is useful because Bash executes its contents after executing any command that I type.

For example: if I type the `date` command, and hit Return, Bash will execute the `date` command, and after that will execute the commands in the `PROMPT_COMMAND` environment variable. Here is a quick example:

```shell
$ export PROMPT_COMMAND='echo YEP'
YEP
$ date
Sat Jul 18 22:16:55 EEST 2020
YEP
$ 
```

So, I’ve set the `PROMPT_COMMAND` to the string `'echo YEP'`. Then I execute the command `date`, and besides the output of `date` itself, I also see the output from `echo YEP`.

Now, besides simple commands like `'echo YEP'`, I can also put a shell function name and it will be executed. So I created a function that, whenever I change the current directory, it will check if there is a `.bash_history` file in it, and if there is, it will tell Bash to use that file as its history, instead of the default `~/.bash_history`[^1].

The function itself is quite straightforward:

```shell
function check_for_local_history {
  function main {
    if found_local_history_file; then
      if [ ! "$PWD" == "$HOME" ]; then
        echo "Using local Bash history"
      fi

      use_history_file "$PWD/.bash_history"
    else
      use_history_file ~/.bash_history
    fi
  }

  function found_local_history_file {
    [ -e .bash_history ]
  }

  function use_history_file {
    history -w
    history -c
    export HISTFILE="$1"
    history -r
  }

  main
}
```

If I’d put the name of this function into the `PROMPT_COMMAND` variable, it will be executed on every command, and I would have achieved my goal, because this function will execute after every command, including when I switch to a directory with, say, `cd ~/src/mixbook_editors`.

The fact that it executes on every command seem abusive, so I look at which command was executed, and only execute the function after a `cd` command[^2].

Now, I only need to create the `.bash_history` in a directory, and when I `cd` into it, Bash picks it up, and yes, I also have a function that creates the `.bash_history` file: [`inith`][0]. 8-)

So now, whenever I start working on a new project, I do something like this:

```shell
mkdir ~/src/igwines
cd $_
inith
initv
cd
cd -
```

Which is this:
- create a new directory;
- `cd` into it;
- call `inith` to create the local `.bash_history` file;
- call `initv`—it does a similar thing for Vim; 8-)
- cd home and back, so that Bash will pick up the local `.bash_history`.

Ta-da! Happy Bashing! :-)

[^1]: Please see [“Bash History Facilities”](https://www.gnu.org/software/bash/manual/bash.html#Bash-History-Facilities-1)
[^2]: Please see [.bashrc.my](https://github.com/gurdiga/dotfiles/blob/80bd639/.bashrc.my#L146)

[0]: https://github.com/gurdiga/dotfiles/blob/80bd639/.bashrc.my#L310-L316
