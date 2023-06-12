---
layout: post
title: make watch-app
date: 2022-11-14 05:18 +0200
tags: [make, unix, shell-scripting]
tags: []
categories: []
---

My name Vlad, and I still like to `make` things in 2022, as in [GNU Make][0]. 🙃

[0]: https://www.gnu.org/software/make/

On [my side project][2], I’ve made a monitoring system based largely on `tail`, `grep`, `jq`, and `ssmtp`, all weaved together into a [UNIX pipeline][1] and packaged as a `make` task. It’s started from the [crontab][3] as system boot, and sends me an email every time a notable event is recorded to the log.

[1]: https://en.wikipedia.org/wiki/Pipeline_(Unix)
[2]: https://github.com/gurdiga/rss-email-subscription
[3]: https://en.wikipedia.org/wiki/Cron

Here is the pipeline:

```sh
tail -n0 --follow=name --retry logs/feedsubscription/{app,api}.log |
grep --line-buffered -E \
        -e '"severity":"(error|warning)"' \
        -e '"message":"Sending report"' \
    |
while read -r _skip_timestamp _skip_namespace _skip_app json; do
    (
        echo "Subject: RES App $(jq -r .severity <<<"$json")"
        echo "From: watch-app@feedsubscription.com"
        echo
        jq . <<<"$json"
    ) |
    if [ -t 1 ]; then cat; else ssmtp gurdiga@gmail.com; fi;
done
```

Here are the interesting bits:

1. Starts with `tail`ing the appropriate logs. I use `-n0` to only look at the new lines as they are added, skip the existing ones. The `--follow=name --retry` is to allow `tail` to work smoothly with log rotation.

1. I filter the lines with `grep` to only get the ones that interest me. I use `--line-buffered` to prevent block buffering: when `grep` delays the output until it collects a bunch of lines. The `-E` is to use some basic regexp magic. A few `-e` args to define the filter conditions, for example `-e '"severity":"(error|warning)"'` catches any error or warning (my logs are in JSON format). I add more as I need them.

1. I collect the logs from all of the system’s containers to a syslog `syslog-ng` container, and so I end up with some additional meta-data fields for every line. This is why I use `read` to split the line into fields, and only look at the actual JSON log message. The `-r` flag is to prevent `read` from interpreting backslashes in the JSON string as shell escapes. I throw away the meta-data fields because I don’t need them here: `_skip_timestamp _skip_namespace _skip_app`.

1. I then use `jq` to extract some bits from the JSON log line, and build an email. For example, I extract the `severity` field and put it in the email subject, and jus dump the entire JSON line, prettified with `jq`, into the email body. Here is an example:

    ```json
    {
      "severity": "info",
      "message": "Sending report",
      "data": {
        "module": "email-sending",
        "feedId": "dexonline",
        "report": {
          "sentExpected": 3,
          "sent": 3,
          "failed": 0
        }
      }
    }
    ```
1. The lil `if` at the end is to help me with debugging: when I run the pipeline manually from the command line, just print the email to console with `cat` instead of sending it out with `ssmtp`.

Happy making and shell pipelining! 🙂
