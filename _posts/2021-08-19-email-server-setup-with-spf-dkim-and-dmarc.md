---
layout: post
title: Email server setup with SPF, DKIM, and DMARC
date: 2021-08-19 20:24 +0300
---

I have recently played with the idea of setting up an SMTP server for a friend’s custom domain, and wanted to share the working setup.

The [boky/postfix][0] Docker image turned out to be quite useful, especially because it’s set up with a mechanism for generating the DKIM keys.

[0]: https://hub.docker.com/r/boky/postfix/

So here are the two steps to sending emails from a custom domain:

## 1. Postfix setup

```shell
$ docker run --rm --name postfix \
    -v `pwd`/opendkim-keys:/etc/opendkim/keys \
    -e "ALLOWED_SENDER_DOMAINS=feedsubscription.com" \
    -e "DKIM_AUTOGENERATE=yes" \
    -e "INBOUND_DEBUGGING=yes" \
    --no-healthcheck \
    -p 1587:587 \
    boky/postfix
```

One more thing about the Postfix container: if you want to persist the queue between container restarts/rebuilds, pass in a volume for `/var/spool/postfix`, for example:

    -v `pwd`/postfix:/var/spool/postfix

## 2. DNS setup: SPF, DKIM, and DMARC

We need to add 3 TXT records in the feedsubscription.com domain:

<div style="overflow: auto">
<table>
<tr><th>Purpose</th><th>Hostname</th><th>Value</th><th>Note</th></tr>
<tr><td>SPF</td><td>@</td><td>v=spf1 mx -all</td><td>See below¹</td></tr>
<tr><td>DKIM</td><td>mail._domainkey</td><td>v=DKIM1; h=sha256; k=rsa; s=email; p=XXXX</td><td>See below²</td></tr>
<tr><td>DMARC</td><td>_dmarc</td><td>v=DMARC1; p=reject; rua=mailto:gurdiga@gmail.com; adkim=s; aspf=s</td><td></td></tr>
</table>
</div>

¹ This particular SPF value assumes we already have a proper MX record.

² The complete definition for the DKIM record is generated by the container because of `DKIM_AUTOGENERATE=yes`, and in this particular setup can be found in `./opendkim-keys/feedsubscription.com.txt`.

## 3. Testing

I used `ssmtp` to test the setup. I needed to have this in `/etc/ssmtp/ssmtp.conf`:

    mailhub=localhost:1587

…then I can send an email:

```shell
$ ssmtp -vvv gurdiga@gmail.com < email.txt
```

Check logs:

```shell
$ docker logs -f <container_name>
```

I specifically enabled logging in above Postfix setup with `INBOUND_DEBUGGING=yes` so that I can see what’s happening.

## A lil closing note

Although I am a little confused about the value of the DMARC record, without it the emails land in the spam folder.

Happy email sending!

## Update Aug 29

Because last week we had a phishing incident at work, I googled some more about the mechanics of SPF, DKIM, and DMARC.

When an SMTP server receives an email from a domain, it can use SFP to verify that the sending server is authorized to send emails for that domain. For example, if I bring up a Postfix container on my laptop, and send an email from info@feedsubscription.com, the receiving SMTP server can check with the DNS for feedsubscription.com, get the SPF record for and verify that my laptop is in the list. If it’s not in the list, it can mark the message as spam or reject it altogether.

DKIM is just an additional level of authentication based on [public-key cryptography][1]. It adds a header to the email message — `DKIM-Signature` — which can be verified by the receiving SMTP server by checking the corresponding DKIM record in the feedsubscription.com DNS.

[1]: https://en.wikipedia.org/wiki/Public-key_cryptography

DMARC builds on both SPF and DKIM, and allows for more sophisticated policies. The receiving SMTP server can look at the DMARC record and decide what to do with every message. And this is why having DMARC — and also SFP and DKIM — gives the sender a higher level of confidence a message will reach its recipient …because the receiver can be more confident.

Here are a couple of links that I found informative:

- [About SPF](https://support.google.com/a/answer/33786)
- [SPF record structure](https://support.google.com/a/answer/10683907)
- [About DKIM](https://support.google.com/a/answer/174124)
- [About DMARC](https://support.google.com/a/answer/2466580)
- [DMARC record structure](https://support.google.com/a/answer/10032169)
- [More DMARC record structure](https://help.returnpath.com/hc/en-us/articles/222437867-What-are-the-different-tags-of-a-DMARC-record-)