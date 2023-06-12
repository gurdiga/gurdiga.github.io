---
layout: post
title: Simple .env
date: '2014-10-04T18:50:00+03:00'
tags: [dev]
categories: []
---
I’ve seen .env being used in Heroku projects, and also in a RubyTapas
episode about Dotenv gem, and I kind of liked it. But I’m reticent to
add more libraries or tools to my toolset, especially if they’re
language specific like Dotenv.

Today I realized that since I use `make` as my primary build tool, I can
just include the .env it in my Makefile:

```make
include .env
.EXPORT_ALL_VARIABLES:
```

and since the .env syntax is essentially the same as the one used in
shell files and in makefiles, it Just Works™. Nice!
