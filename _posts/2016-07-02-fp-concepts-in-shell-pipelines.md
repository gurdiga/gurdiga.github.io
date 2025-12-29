---
layout: post
title: FP concepts in shell pipelines
date: '2016-07-02T15:26:12+03:00'
tags: [bash, shell, fp, patterns]
---
The other day I was faced with a little task at work: find in the
current repository subdirectories that contain a file named
render-javascript.js and zip those directories one by one. Here is what
came out:

```bash
find . -name render-javascript.js | xargs -n1 dirname | xargs -n1 -i zip -r {} {}
```

Here is what’s going on:

In the first segment of the pipe I find the files; the result is similar to this:

```bash
~/src/xo ɀ  find . -name *Field.js
./app/utils/createField.js
./app/widgets/ActivityDateField.js
./app/widgets/DateField.js
./app/widgets/LabeledDateField.js
./app/widgets/LabeledLargeTextField.js
./app/widgets/LabeledSelectField.js
./app/widgets/LabeledTextField.js
~/src/xo ɀ
```

Next, each line — this is what `-n1` does for `xargs` — is passed to
`dirname` which prints the directory portion of a path.

Having the required directory paths, I can pass each of them to `zip`.
Here I use a little `xargs` trick: passing it `-i` gives you the ability
to mention the input line multiple times within the command by using the
`{}` placeholder. So given our command `zip -r {} {}` and a line like
`./app/widgets` the final command will be `zip -r ./app/widgets
./app/widgets`.

That’s it! Yes, I could do the same thing a `for` loop, but I like that
the process is neatly split in discrete steps. 8-)

\* * *

Marveling at this command, I realized that it’s a lot like a promise
chain, or an FP composition. The latter may look like this:

```js
var zipDirectoriesContaining = compose(zip, dirname, find);

zipDirectoriesContaining('render-javascript.js');
```

While code like this looks quite cool, as does a promise chain and a
shell pipeline, it has 2 little drawbacks:

1. The IO protocol is implicit: you have to assume that the output value
	 each function is appropriate as input for the subsequent one. I guess
	 this may be fine if all those functions have a filter-like API, but
	 to me it feels a bit implicit.
2. At any given step I don’t have access the value of previous ones. For
	 example if in the `zip` function I wanted the name passed to `find` —
	 for example to record it in a log file along with the final directory
	 name — I can’t get that.

But “drawback” only means that that particular solution is not a perfect
fit for the problem at hand.
