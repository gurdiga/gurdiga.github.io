---
layout: post
title: One misuse of SameSite=Strict cookies
date: 2020-06-20 13:34 +0300
---

The _Change Email_ feature on my side-project broke a few days ago.

The usual stuff:
- user authenticates and clicks “Change email”;
- enters the new email and receives a verification link.

The trouble was that clicking the verification link would end their session. Hmm… Interesting. Even more interesting was that if I’d _copy-and-paste_ the verification link into the browser, it would work. Hmm… 🤔

After googling a couple of days, I thought that if the URL is the same, and it works when I paste it in the browser, but doesn’t when I click it in email, then the difference must be the somewhere in the HTTP headers.

So I printed the headers as early as possible on the server, and comparing them I found that the cookies were not being sent when clicking the link in the email. Besides that there was this [`Sec-Fetch-Site`][1] header that was different: when clicking the link in the email it was `cross-site` instead of `same-site` when pasting the URL directly. This kind of makes sense: the browser goes from Gmail to my website, so, yeah, it’s _cross-site_.

[1]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Sec-Fetch-Site

It somehow dawned on me after some time that this might be related to the session cookie that I vaguely recalled having a similar attribute: `SameSite`; I had it set to `Strict`.

Yeah, that was it: because the request was going from one site to another, from Gmail to my site, the browser was adding the `Sec-Fetch-Site: cross-site` HTTP header, and also was not sending the cookies with `SameSite=Strict`. The fix was to delete the `SameSite` attribute from the session cookie, which at the moment [is the same][2] as `SameSite=Lax`.

Today I Learned™. 🙂

[2]: https://web.dev/samesite-cookies-explained/#samesitelax-by-default
