---
layout: post
title: 'Heroku: a PaaS for stress reduction'
date: 2020-02-29 12:47 -0800
tags: []
categories: []
---

One of the items that I had planned for this sprint was to fix the deployment system. Well, the “system” is a bit too grandiose for [a Bash pipeline][1] in the `Makefile`. The essence is that I didn’t pay too much attention to it after a couple of initial deploys, and then one day I went to the public URL and the app didn’t come up. I logged into the DigitalOcean server, and felt lost: didn’t really remember the commands to check for the system service status, didn’t know how to verify if the code is up to date.

[1]: https://github.com/gurdiga/repetitor.tsx/blob/10bb87f/Makefile#L139-L145

I have to say that it was a bit of a struggle to get it working in the first place. As much as I love to tinker with UNIX systems, I don’t want that to be a major thing on this project. I’d like it to just work, and the current “solution” was clearly not that.

A few years ago I had [a Node app][2] on Heroku, and I remembered the “git-push” experience of the deploy that I had then. So I decided to take another look at Heroku for this current project.

[2]: https://github.com/gurdiga/pinj-search-engine

As an aside, at the end of the past year, I have decided to move the project [out of AWS][3] because its benefits were greatly outweighed by the complexity that I found it brought. I moved the app to a server in DigitalOcean where I had a couple of other things, and which gave me the feeling of getting back the control and understanding of what is happening in the backend. It was a great intermediate step.

[3]: https://github.com/gurdiga/repetitor.tsx/commit/a6890d6862de60ca0bf7d712e4b1569630bc5f59

So now I was looking at Heroku and trying to figure out if it’s a good fit for what I need. After going through a few guides on Node support, it turned out to be quite smooth, partly because I have recently re-read their “The Twelve-Factor App,” and the app structure was quite aligned with their recommendations. In two evenings, I got it up and running: any push to master on GitHub triggers a deploy. I love that it’s so hands-off.

The thing that triggered this article was that evening a couple of days before when after I got the deploy to Heroku et up, I closed my laptop and went to brush my teeth. As I entered the bathroom I couldn’t but notice how at ease I felt: it made me smile. 🙂

For the last couple weeks I have researched deploy tools: I had a close look at Capistrano and other similar tools, partly to understand what a reliable deploy system looks like, and partly to decide if I want an off-the-shelf solution, or just write a Bash script to upload it to DigitalOcean. Neither seemed perfect, so I had this unresolved question in the back of my mind for some time. And now, seeing how simple it turned out with Heroku, all that tension went away. Awesome.

This reminded me of a conversation I had a couple weeks ago with a writer. I helped her move [her website][4] from an antique Yahoo! hosting service to DigitalOcean. There were a bunch of changes going on at Yahoo! in the last years, some features of the site broke and she, being in her 60s, had not much of an idea what’s going on or what to do about it. I came across her posts [on a maling list][5] and offered help. In a couple of months of poking and testing, I got it moved. Here is a quote from her email:

[4]: https://sandradodd.com/
[5]: https://groups.io/g/AlwaysLearning

> Yesterday I worked on fixing up some pages. I’m getting used to the editor and liking it more and more.  I’ve been sleeping better. I’ve been cheerier, knowing that changes I make are likely to stay there a long time. I didn’t realize how stressed I was over the problems. I knew it was bad, but it seems it was affecting my health more than I knew. :-)
> Relief is very… relieving. :-)

I think now I better understand what she meant. 🙂
