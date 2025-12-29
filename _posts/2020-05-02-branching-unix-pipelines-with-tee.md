---
layout: post
title: Branching UNIX pipelines with tee
date: 2020-05-02 14:15 +0300
tags: [bash, shell, tools, typescript]
---

I have a confession to make: I’m a bit of a UNIX geek. You can tell that by looking at my [dot-files][0] and also by the fact that I have a `Makefile` in most of my repos.

[0]: https://github.com/gurdiga/dotfiles

In one of my side-projects, I have a `watch` build task that starts the TypeScript compiler in watch mode, and it’s been kind of annoying to go look at the terminal window after changing my code to see when it was done recompiling.

So I thought that it would be nice to get a desktop notification telling me when it was done, or when it failed so that I don’t need to jump between terminal windows. The output looks like this:

```
3:04:46 PM - Starting compilation in watch mode...
3:04:47 PM - Found 0 errors. Watching for file changes.

3:11:46 PM - File change detected. Starting incremental compilation...
3:11:50 PM - Found 0 errors. Watching for file changes.

3:11:54 PM - File change detected. Starting incremental compilation...
backend/src/Utils/FileStorage.ts(5,44): error TS2304: Cannot find name 'strong'.
3:11:56 PM - Found 1 error. Watching for file changes.
```

I don’t want to interfere with its output so that I can see it in whole as it pours, I just want to run a command when I see a specific line — in a way, I want to “branch” the pipeline and do some additional work with it while keeping the initial stream flowing undisturbed.

One way to do this is by using the `tee` program from GNU Coreutils: it pipes-through its input while also writing it to another file. Here is what came out:

```shell
tsc --build --watch | tee >(
    while read line; do
        STATUS_LINE=`echo $line | grep -Po 'Found \d+ errors?'`

        if [ ! "$STATUS_LINE" ]; then
            # I am not interested in this line, ignore it and continue.
            continue;
        fi

        if [ "$STATUS_LINE" = "Found 0 errors" ]; then
            # Display the 👍 notification.
        else
            # Display the ❌ notification.
        fi
    done
)
```

The `>(commands...)` syntax is called [_process substitution_][2] and can also be helpful when you have a multi-step pipeline and you want either to capture the output at the intermediate steps, or just for debug it by `tee`-ing the output to STDERR. There are more examples in the [docs][1].

[1]: https://www.gnu.org/software/coreutils/manual/coreutils.html#tee-invocation
[2]: https://www.gnu.org/software/bash/manual/bash.html#Process-Substitution

Happy scripting!
