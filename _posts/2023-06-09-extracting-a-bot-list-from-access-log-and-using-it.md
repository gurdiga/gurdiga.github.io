---
layout: post
title: Make a bot list from access.log and use it
date: 2023-06-09 10:34 +0300
tags: [grep, unix, scripting]
categories: [tech]
---

The other day, after playing a bit with [GoAccess][goaccess] I found that the numbers didn’t add up with my in-app tracking, and I decided to take a slice of access.log and eyeball it to see what’s going on. What I found was discouraging: lots an lots of bot and crawler requests. As disappointing as it was, it was still good to find this out and adjust my perception to reality.

[goaccess]: https://goaccess.io/

It was also disappointing that `--ignore-crawlers` of GoAccess was still letting through a lot of bot requests, so from the knowledge that I gathered from looking through access.log, I decided I will let it do its thing — the pretty charts and stats, but filter the log records myself.

To do the filtering I needed a list of known bot user-agent names, and when I couldn’t google it, I decided I will extract my own bot list from the some 11 months of logs I had from [FeedSubscription.com][0]. I’m posting the list below, just for reference.

[0]: https://feedsubscription.com/

Here is the UNIX pipeline that I used to extract it:

```sh
base_re='\w*(bot|crawler|spider)\w*'

zcat -f /var/log/access.log* | # look into compressed and uncompressed logs
grep -Eoi '" [0-9]+ [0-9]+ ".*'"$base_re" | # only lines with something-BOT-something in the UA string (or referrer)
grep -Eoi "$base_re" |
```

Essentially, I look for words that contain "bot" or "crawler" in the user-agent string. Besides that, I found some UA strings that didn’t match, but I recognized the names, and added included them in the list:

```
Chrome-Lighthouse
Google-InspectionTool
HeadlessChrome
scaninfo@paloaltonetworks.com
Feedly
Go-http-client
Nmap Scripting Engine
facebookexternalhit
facebookcatalog
```

Combining these two lists, I get stats that are much closer to what I see in the built-in tracking.

Here is how I use this list to filter out bot requests:

```sh
bot_list_re="($(cat bot-list.txt | paste -sd '|'))"

zcat -f /var/log/access.log* |
grep -vPi ".*$bot_list_re.*"
```

…which is essentially combining them all in a large regex like `(name1|name2|name3|name4)`.

## bot-list.txt

```
AdsBot
AhrefsBot
aiHitBot
Applebot
bingbot
BitSightBot
bot
bots
BSbot
CCBot
Chrome-Lighthouse
crawler
DataForSeoBot
domainsbot
DotBot
Exabot
facebookcatalog
facebookexternalhit
Facebot
Feedly
Go-http-client
Google-InspectionTool
Googlebot
GulperBot
HeadlessChrome
LinkedInBot
MJ12bot
MojeekBot
msnbot
Nicecrawler
Nmap Scripting Engine
org_bot
Pinterestbot
QBOT
redditbot
RepoLookoutBot
robot
robots
RU_Bot
scaninfo@paloaltonetworks.com
SemrushBot
serpstatbot
SeznamBot
Slackbot
SuperBot
t3versionsBot
TelegramBot
top1mbot
Twitterbot
VelenPublicWebCrawler
Vercelbot
webprosbot
WhatStuffWhereBot
YandexBot
YandexRenderResourcesBot
ZaldamoSearchBot
ZoominfoBot
```
