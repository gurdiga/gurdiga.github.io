---
layout: post
title: Simple log aggregation for Docker containers
date: 2021-09-19 11:16 +0300
tags: [docker]
excerpt_separator: <!-- excerpt -->
---

## The Why

The Docker composition on one of my side projects has recently got to 6 containers: SMTP-in, SMTP-out, app, subscription, website, and certbot. Since I have deployed a `0.1.0` version to DigitalOcean a couple of weeks ago, I caught myself feeling increasingly anxious about losing logs every time I deployed a new version of the container.

<!-- excerpt -->

Every container is streaming its logs to STDOUT. I wanted to have a persistent log file for each container, which [Docker almost does][0] out-of-the-box, with the “little” caveat that those files are removed every time the container is rebuilt. 🙃

[0]: https://docs.docker.com/config/containers/logging/local/

One of the things that I’ve challenged myself to do on this side project is to have it as self-contained as possible. — This is why I’ve set up my own SMTP server instead of buying a transactional email subscription. 😎

This is the kind of simplicity I was referring to when I said “simple log aggregation” in the title: no third-party services. I wanted it to be a Docker composition that I can start on my laptop as easily and as cleanly as on a VM in some cloud.

At the end of the day, all I needed is to have those logs — plain text or JSON — stored somewhere so that I can `grep` or [`jq`][8] them whenever I want to do see what happened when.

[8]: https://stedolan.github.io/jq/

After googling around for a few mornings, I ended up deploying an additional logger container that runs Syslog and then instructed all the other containers to stream their logs into it. I’ve seen this called “the sidecar pattern” in other places. The logger container’s files live in a mounded directory, so they can have a life outside Docker, and across the container life cycle.

## Some dirty details

### The logger

I’ve started with the [`mumblepins/syslog-ng-alpine`][3] for the proof of concept, but then I saw a warning about old log format, or something. On a closer inspection, I realized that it hasn’t been updated in 4 years. Hm… Looking at [its Dockerfile on GitHub][1] I found that it was manually compiling Syslog from the source. Umm… OK. On the next day, inspired by that I’ve created [my own Dockerfile][2], which used Alpine’s built-in package of Syslog.

Extracted a copy of its config file from the running container, added [the bits][9] from `mumblepins` that made it listen on the network, and with that I had it both up to date and working. Open Source is awesome. 😎

[1]: https://github.com/mumblepins-docker/syslog-ng-alpine/blob/df1e224/Dockerfile
[2]: https://github.com/gurdiga/rss-email-subscription/blob/70fa0e4/docker-services/logger/Dockerfile
[3]: https://hub.docker.com/r/mumblepins/syslog-ng-alpine/
[9]: https://github.com/mumblepins-docker/syslog-ng-alpine/blob/58eac18/syslog-ng.conf

### The docker-compose config

To tell a container to stream its logs to a Syslog is [well documented][4], and quite straightforward:

[4]: https://docs.docker.com/config/containers/logging/syslog/

```yaml
app:
  # ...more settings...
  depends_on: [logger]
  logging:
    driver: syslog
    options:
      syslog-address: tcp://127.0.0.1:514
      syslog-format: rfc3164
      tag: subscription
```

This worked, but having this for 6 services looked too non-[DRY][5] for my taste, so I googled around for a morning or two and found about [YAML merge type][6] which is described under the [**Extension fields**][7] section of Docker Compose references, and which gave me this:

```yaml
x-logging: &logging
  depends_on: [logger]
  logging:
    driver: syslog
    options:
      syslog-address: tcp://127.0.0.1:514
      syslog-format: rfc3164
      tag: {% raw %}"{​{.Name}}"{% endraw %}
```

I added the `tag:` option to have the symbolic container name in logs instead of its hex ID. And so this snippet now allows me to include it in every service’s config like this:

```yaml
smtp-in:
  container_name: smtp-in
  # ...
  <<: *logging
```

This is neat. 🤓

[5]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
[6]: https://yaml.org/type/merge.html
[7]: https://docs.docker.com/compose/compose-file/compose-file-v3/#extension-fields
