---
layout: post
title: moreutils ifne run function
date: 2021-11-28 13:00 +0200
tags: []
categories: []
---

There is this lil program in moreutils called [`ifne`][0]. I use it in shell pipelines, to execute a given command when there is some output. A quick example:

[0]: https://linux.die.net/man/1/ifne

```sh
grep "^`date +%F`" logs/feedsubscription/api.log \
| grep '"message":"subscribe"' \
| ifne mail -s "Subscription requests" root
```

This will grep the API log, and email me today’s subscription requests, but only if there are any. It won’t do anything if there are no records found — and that’s exactly its whole purpose: only run the command if anything comes into STDIN.

Its limitation is that I can only run _one command_ on that STDIN, and I wanted to do some more processing on it before passing it to the next command in the pipeline. Specifically this: grep some log file and email the matching lines, but first prepend some headers, which would look like this:

```sh
grep 'something' file \
| (
    echo "Subject: Subscribe report"
    echo "From: subscribe-report@feedsubscription.com"
    echo ""
    cat
) \
| ssmtp gurdiga@gmail.com
```

This doesn’t work as I wanted because it would send the email even if no lines matched. So I thought: if I pack the pre-processing and the sending in a `send_report` function, I’d be able to call that function with `ifne` only when there are matching lines, something like this:

```sh
grep 'something' file | ifne send_report
send_report: No such file or directory
```

…it seems like it doesn’t work with _functions_. After some googling, I found this approach:

```sh
export -f send_report
grep 'something' file | ifne bash -c send_report
```

It’s a bit awkward, but still readable and does what it needs to do.
