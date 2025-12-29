---
layout: post
title: Keeping secrets in a node app
date: '2014-08-26T10:41:04+03:00'
tags: [dev]
---
For some time I was looking for a way to safely store my app secrets like API keys. Environment variables are OK, they work, but I found it cumbersome. I had a Heroku project where this worked with a .env file that looked like this:

```bash
FIREBASE_BNM_SECRET=THE_VALUE
```

Nice, useful, and simple. It gave me a way to neatly store production
and development secrets. I was wondering how would I get a as simple
thing for my other node apps, and today I came up wit secrets.json:

```json
{
  "FIREBASE_BNM_SECRET": "THE_VALUE"
}
```

Now I simply say `var secrets = require('./secrets');` and I have them
handy. Nice, useful and simple.
