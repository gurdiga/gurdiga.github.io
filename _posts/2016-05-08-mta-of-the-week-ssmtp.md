---
layout: post
title: 'MTA of the week: sSMTP'
date: '2016-05-08T11:35:11+03:00'
tags: [email]
---
I fiddled with a couple of servers in the past weeks and one of the
things I needed immediately was email. I wanted to allow `cron` and the
webapps to send out emails.

The first thing I tried is Postfix. I couldn’t get it right from the
first time and stepped away in frustration. I have a free Mailgun
account, which already set up and running well. And so, I wanted some
way to get the email to Mailgun, and everything would be fine from
there. This was happening on Digital Ocean and so I googled frantically
“digitalocean mailgun.”

One of the threads in the results mentioned `sSMTP`. It seemed to do
exactly what I needed: allow a system to send email out. Here is a
couple of snippets of its README:


> This is sSMTP, a program that replaces sendmail on workstations that
> should send their mail via the departmental mailhub from which they
> pick up their mail (via pop, imap, rsmtp, pop_fetch, NFS… or the
> like).  This program accepts mail and sends it to the mailhub,
> optionally replacing the domain in the From: line with a different
> one.
>
> WARNING: the above is all it does. It does not receive mail, expand
> aliases or manage a queue.  That belongs on a mailhub with a system
> administrator. […] It uses a minimum of external configuration
> information, and so can be installed by copying the (right!) binary
> and an optional four-line config file to a given machine.

here is one from its Debian page:

> sSMTP is a simple MTA to deliver mail from a computer to a mail hub
> (SMTP server). sSMTP is simple and lightweight, there are no daemons
> or anything hogging up CPU; Just sSMTP. Unlike Exim4, sSMTP does not
> receive mail, expand aliases, or manage a queue.

I’ve tried it, it worked perfectly, and we became good friends. :-)

So next time when you need to send email out of a system, give it a try!
8-)
