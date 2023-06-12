---
layout: post
title: Expressive JS: askToConfirm
date: '2016-04-04T09:27:57+03:00'
tags: [js]
categories: []
---
The other day at my day job I needed to change some buttons to ask for
confirmation before executing the actual action.

This was in the context of some Marionette view that looked like this:

```js
return Marionette.ItemView.extend({
    template: template,

    ui: {
        duplicate: '#js-duplicate'
    },

    events: {
        'click @ui.duplicate': duplicateThatThing
    },

    //...

});
```

Looking at this I though: it’d be neat to be able to say something like:

```js
'click @ui.duplicate': askToConfirm(duplicateThatThing, confirmationMessage)
```

Yeah, it would. 8-) So I have set out to write `askToConfirm`. I
actually ended up packing it into its own widget —
`ConfirmationDialogView` — but the original idea remained intact: I can
now take any event handler and put a nice confirmation dialog before it.
So given something like this:

```js
'click': handler
```

I only need to make it like this:

```js
'click': ConfirmationDialogView.askToConfirm(handler, confirmationMessage)
```

The source file is about 130 lines, and it’s not that interesting to
post here, but I liked it so much that I thought I’d write to brag about
how expressive code can be in JavaScript. :)
