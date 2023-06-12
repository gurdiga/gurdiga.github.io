---
layout: post
title: Online presence for $5 a month
date: 2020-06-27 13:25 +0300
tags: []
categories: []
---
A few months ago a friend asked for help with the degrading quality of their web host. At that time they had an old all-in-one service that was hosting their static website that they edited by hand, DNS, and email. I have done that a couple more times for the domains that I owned and for my other people, and I offered my “solution”:

- $0/mo DNS: Cloudflare free account;
- $5/mo server on DigitalOcean for the static website;
- $0/mo email: Mailgun free account + Gmail free account.

The domain name cost was not included here.

The first thing that I did was to move the DNS zone to Cloudflare. This would allow me gradually move the email and website, one by one. Cloudflare has pretty good documentation, and I’m not including any of them here because they can get out of date and confuse someone who reads this in  a year or two.

Next came the email:
- I created a free account on Mailgun;
- added the domain;
- set up the email forwarding to the Gmail address;
- set up the Gmail account to be able to additionally send email from the new domain.

I changed the MX records in DNS to point to Mailgun servers and send a few emails back and forth to see how it works. If anything went wrong, I would change it back while I fix the issue.

I have set up the server on DigitalOcean with 2 main things:
- nginx for the static website;
- Droppy web file manager for editing files.

I have attached it temporarily to a different domain that I owned so that my friend can check it out and point to anything that was not working as expected. On the old web-host, there were a bunch of non-standard routing rules, and I those was the first thing that I needed to get working. It was stuff like `/some/page.html` needed to work for both `/some/page.html` and `/some/page`. The same for images: an image would need to work for `/image.gif` and also for `/image`. Yeah, weird, but there were a lot of internal links on the website that were structured this way, and it would break without all of this weirdness working. So this one took a while.

The next big thing was to find a web UI for file management and editing: [Droppy][1] worked well for my friend’s needs.

[1]: https://github.com/silverwind/droppy

That’s it. The is some maintenance work I have put on my calendar for the server, like installing updates, but besides that, everything Just Works®.
