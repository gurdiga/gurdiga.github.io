---
layout: post
title: make nvm node
date: '2018-03-27T23:30:00+03:00'
tags: [make, nodejs, tools, bash]
---

Today I launched on a new project and there was a specific Node version
required, specified (strangely) in `package.json`. I’ve expected it to be in
`.nvmrc`, but never mind, I had to get it working, and I wanted it working with
`make`, as I do for every new project.

I create a new `Makefile` where I usually have a `start` task to start whatever
service I need for the app. For a Rails app, it’s have something like this:

```make
start:
  bundle exec rais s
```

With a Node app though, one that requires a specific version of Node, as in this
specific case, I needed to run something like this:

```
nvm exec 9.8.0 yarn start
```

…which, in a Makefile wouldn’t work because the commands are run in a new shell,
and NVM is implemented as Bash functions, so `nvm` can’t be called from
a Makefile. It’s quite easy to google the `nvm` GitHub issue on that:
[#1446](https://github.com/creationix/nvm/issues/1446), which recommends this:

```bash
bash -l -c 'nvm exec $(NODE_VERSION) yarn'
```

OK, but if you have more than one task, then this repetition becomes
unacceptable, especially if you have to have a specific Node version, so I wrote
a `make` function to hold the common parts:

```make
define yarn
  $(eval npm_script_name=$(1))
  $(eval node_version=$(shell jq -r .engines.node package.json))

  bash -l -c "nvm exec $(node_version) yarn $(npm_script_name)"
endef
```

…and now, to call the `"start"` NPM scrip, I say:

```
start:
  $(call yarn, start)
```

…and, similarly for the other things that I want to `make`:

```
setup:
  $(call yarn, setup)

clean:
  $(call yarn, clean)

test:
  $(call yarn, test)
```

Neat! Now I can use my muscle memory to launch the server, or the tests,
or whatever else I need. 🤓
