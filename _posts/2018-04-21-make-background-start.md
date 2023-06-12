---
layout: post
title: make background start
date: 2018-04-21 11:29 +0300
excerpt_separator: <!-- excerpt -->
tags: []
categories: []
---

I have a couple of Jekyll-based websites, and my `make start` looks something
like this:

```
start:
	bundle exec jekyll serve
```

This works. I run it in another terminal tab, and `^C` it when I’m done. The
other day though, I thought it’d be nice if `make start` would run in the
background and then say `make stop` when I’m done. Here is what came out. 🤓

<!-- excerpt -->

Yeah, I know about `jekyll serve --detach`, but I wondered if there was a nicer
more generally-usable way to get something launched in the background, capture
its `STDOUT` and `STDERR` into a log file, and then be able to stop it when I’m
done.

Technically speaking, this does the job:

```
start:
	jekyll serve &> $(SERVER_LOG_FILE) & disown; echo $$! > $(SERVER_PID_FILE)
```

Let me explain, bit-by-bit:

* `&> $(SERVER_LOG_FILE)` — redirects
[both](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirecting-Standard-Output-and-Standard-Error)
`STDERR` and `STDOUT` to the given log file;
* `& disown` — are actually 2 pieces:
[`&`](http://bashitout.com/2013/05/18/Ampersands-on-the-command-line.html) tells
the shell to run the command in the background, and
[`disown`](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Builtins.html)
makes it not show up in the job list, and also it will
[not](https://www.gnu.org/software/bash/manual/html_node/Signals.html) get
`SIGHUP` if the terminal closes;
* `echo $$! > $(SERVER_PID_FILE)` — saves the PID to a file for `make stop` to
use.

If the PID file already exists, this probably means that the server is already
running, and I should’t try to run it again, so I add this check:

```
start:
	@test -e $(SERVER_PID_FILE) \
		&& echo "$(SERVER_PID_FILE) already exists. The server is probably already running." && exit 1 \
		|| echo "Starting the server..."
	jekyll serve &> $(SERVER_LOG_FILE) & disown; echo $$! > $(SERVER_PID_FILE)
```

Then `make stop` is just this:

```
stop: $(SERVER_PID_FILE)
	kill `cat $(SERVER_PID_FILE)`
```

I’ve added `$(SERVER_PID_FILE)` as a dependency here because there is no point
in trying to do this if there is no PID file. This works, but the built-in error
message that `makes` throws when there is no PID file, is not very nice:

```
make: *** No rule to make target `.tmp/server.pid', needed by `stop'.  Stop.
```

So, to make this nicer, I’ve added this:

```
$(SERVER_PID_FILE):
	@echo "No $(SERVER_PID_FILE) file. The server is probably not running." && exit 1
```

…which gives me this:

```
No .tmp/server.pid file. The server is probably not running.
make: *** [.tmp/server.pid] Error 1
```

Neat! 🤓
