---
layout: post
title: 'My own hackathon: day 4/14'
date: '2015-05-22T19:19:46+03:00'
tags: []
categories: []
---
Today I worked pretty smooth once I got into the flow. And I feel a bit more tired than usual and I have some theories on why.

One thing that I would have done otherwise in retrospect — that I also mentioned yesterday — I took on a task that I didn’t know I’d be able to finish. A couple of days ago [I’ve reported a bug in React Dev Tools](https://github.com/facebook/react-devtools/issues/91) and this morning I got a comment on that GitHub issue which was asking me to dig a little bit in it and maybe propose a patch. The issue is in a Chrome extension, so I fiddled a bit with it until I found the cause but not a solution: it looks like a platform issue to me, and I just posted a reply on the issue. It took me a couple of hours, and being a relatively unknown territory it was pretty draining too. I guess I should have just left it for the end of the day.

Of course I wanted to contribute to an open-source project — especially being a React tool, it’s like a medal of honor or something! :o). It’s probably not a bad thing in itself, it was just not the best time for it.


> Note again: First do things that you know how to do.


One other thing that I think led to this tired feeling is that almost all day long I listened to podcasts¹. They were pretty intense in the sense that there was a lot of interesting information that I wanted to take note of, and I guess this consumed a good chunk of my brain power too.

¹ The “Startups For the Rest of Us” that I found yesterday: trying to catch up I have downloaded about 20 episodes.


> Note 2: Take it easy on podcasts. Switch to relaxdaily, classics, or just unplug if there is not a lot of noise in the office.


On the coding side, I have extracted a few useful React mixins. Then I googled around on mixin composition and found a few quite contradictory opinions on them, especially in the context of ES6 React. I decided that since they work for me now, I will keep using them, and if later a better reuse technique comes out, I’ll see then.

One neat twist that I come up with today is a mixin to pass props on:

```js
var DateField = React.createClass({
  mixins: [Styled, InheritProps],

  render: function() {
    return (
      <TextField
        value={this.getValue()}
        {...this.makeInheritProps('label', 'id')}
        {...this.makeStyled()}
      />
    );
  },
  ...
```

The this.makeInheritProps function comes from InheritProps and returns a plain JS object, which is then spread into props — {…}. Since it’s the new shiny toy, I think I may overuse it, but for now I thin it reads pretty well. :-)
