---
layout: post
title: My 3 Why TypeScript
date: 2017-02-25T12:30:46+00:00
tags: []
categories: []
---

The other day I [gave a short
talk](https://www.facebook.com/events/1856699564545244/) at our local
[JavaScriptMD](https://www.facebook.com/groups/javascriptmd/) meetup: “3
ways to improve your JavaScript with TypeScript,” and I thought writing a
summary of it may be a nice way to enliven my blogging.

So:

- [History](#history)
- [Conversion](#conversion)
- [In a few bullet-points and a picture](#directin-a-few-bullet-points-and-a-picture)
- [The 3 ways, in detail](#directthe-3-ways-in-details)
	- [Read](#directread)
	- [Write](#directwrite)
	- [Change](#directchange)
- [The superpower](#directthe-superpower)
- [Outro](#directoutro)
	- [Two links](#directtwo-links)

## History

I’ve programmed in JavaScript for quite some time now. I think I’ve
discovered it in early 2000s and played with it because I was curious
what is this new Web thing, and what can I do with it.

I was mostly playing with it outside of the job, but never lost a chance
to bring it in to add some magic to the company’s website. Then in 2005
I got a full-time and full-stack JavaScript job: on the front-end we had
YUI/EXT and in the back-end we had
[JScript](https://en.wikipedia.org/wiki/JScript) (classic ASP), and
since then, even I was also doing things across the stack, I felt mostly
like a JavaScript and Web front-end person.

In the last few years I even started a couple of side-projects that I
wrote in JS, again both front-end and back-end, where now I had Node.
These projects made me think deeper about my JavaScript skills and stack
because I was the only one tech person on each of them, and I could pick
the best things and ways to build them. (I was not ready to bring in
anyone else yet, because I didn’t want to share the risk.)

As of half a year ago, my attitude was that I can do most of the things
that frameworks and module loaders do, but just with less overhead in
the development process: I was (and still am) quite ascetic when picking
my stack.

There was one thing that I began to feel: while JavaScript gave me all
the flexibility in the world to build things how I saw fit, it was also
leaving me to my own devices when codebases grew beyond of a few files,
and I was feeling more and more tensed to change the code to reflect my
new understanding of the business logic that I was modeling.

Unit tests helped, and while I was writing a ton of them, I began to
worry about them: they are JavaScript code too, aren’t they? At some
point I began to feel bogged down by my own, dear, beautiful code…

## Conversion

About a half a year ago I came at
[Mixbook](https://www.mixbook.com/about-mixbook) to help out with a new
front-end project. The stack was TypeScript + React, but I decided I’d
give it a try because Mixbook culturally wowed me the few times we’ve
met in person with [Aryk](https://www.linkedin.com/in/arykgrosz) (CTO
and cofounder) and a couple other people online.

A month ago, after going to our local JavaScriptMD meetup I was ripe to
give a talk on why I found TypeScript so useful to me as a Native
JavaScripter®.

## In a few bullet-points and a picture

- A superset of ES.Next + transpiler + type checker: While the first two
	are valuable too, the latter is what I found to be the biggest thing.
	It’s that diligent and tireless assistant that helps you when your
	code grows beyond what you have ever expected.
- [Open Source®](https://github.com/Microsoft/TypeScript)
- Is written in TS: I’m mentioning this not because it sounds geeky,
	but because I see this as an added bit of guarantee: if its creators
	use it themselves, they will keep it practical.
- inference → optional types: Another one of the biggest points about
	TypeScript, and which make it stand out of the static typing
	languages (more on this later).
- ~[adjustable](https://www.typescriptlang.org/docs/handbook/compiler-options.html)
	level of strictness: A few knobs to adjust the level of how much it’ll
	let you shoot yourself in the foot.

<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg" width="400" height="400">
  <circle cx="100" cy="100" r="100" fill="#006ab6"/>
  <text x="50" y="50" font-family="Lucida Grande" font-size="20" fill="white">
    TypeScript
  </text>

  <circle cx="100" cy="130" r="65" fill="#bad1e5"/>
  <text x="85" y="110" font-family="Lucida Grande" font-size="20" fill="black">
    ES6
  </text>

  <circle cx="100" cy="155" r="35" fill="#fcfcfc"/>
  <text x="85" y="160" font-family="Lucida Grande" font-size="20" fill="black">
    ES5
  </text>
</svg>

> Thanks to
> [@basarat](https://medium.com/@basarat/typescript-won-a4e0dfde4b08)
> for the visual concept.

## The 3 ways, in detail

- read
- write
- change

### Read

Having types let you see at a glance what a function expects and
returns. What is equally important is that they tell the type checker
what we intended to say, and because of this it will be able to guide
your code so that it does the right things to the input and returns what
we expect.

Here is an example from the entry point function of our project:

```
export function main(container: Element,
                     projectJson: ProjectJson,
                     configJson: ConfigOptionsJson,
                     externalCallbacks: ExternalCallbacks): ApplicationManager {
```

What is ProjectJson? ConfigOptionsJson? That’s easy to tell because we
have them described in real, concrete code:

```
export interface ProjectJson {
  id?: number;
  creator?: UserJson;
  name?: string;
  pages?: PageJson[];
  photos?: PhotoJson[];
  template?: ProjectTemplateJson;
  intended_product?: ProductJson;
}
```

This will help the type checker help us keep the whole thing straight,
and will also help the developers see what exactly is that argument.

Because we spend a lot more time reading our code than writing, you
can’t overestimate the value of clarity that these definitions give to
your team.

### Write

Let’s say we want to models a basket for an e-commerce website. I’d
begin with something like this:

```
interface Basket {
  items: Item[],
  lastUpdate: Date | number,
}
```

and then I’d say:

```
interface Item {
  id: number | string,
  name: string,
  quantity: number,
  price: number,
}
```

These definitions make the ideas in my head concrete, and not only to me
but also to the type checker — the useful assistant that will work
alongside with us to keep the code straight with our intentions
specified in these declarations. Now when I write the code that works
with these data structures, the type checker will guide me towards
meeting those intentions.

```
const basket: Basket = {
  lastUpdate: Date.now(),
  items: [{
    id: 1,
    name: "Pixel",
    quantity: 2,
    price: 2000
  }]
};

function totalAmount(basket: Basket) {
  return basket.items.reduce((memo, item) => {
    return memo + item.quantity * item.price;
  }, 0);
}

// Here the type checker will tell be able to us immediately that:
// “Property 'length' does not exist on type 'number'.”

console.log("Total amount: " + totalAmount(basket).length);
```

Writing the code to work with these data structures is where
TypeScript’s ability to infer types shines: The code can still be
concise, we didn’t need to specify the type of every little thing in the
code:

- because we specified that `totalAmount`’s argument is of type `Basket`
	the type checker _inferred_ that it’s OK to access its `items`
	property;
- because we defined that `basket.items` is an array of `Item` objects,
	it _inferred_ that it’s OK to call `reduce` on it;
- because we defined that `basket.items` is an array of `Item` it
	_inferred_ that the reducer function’s second argument has type `Item`
	— we didn’t need to tell it again;
- because the second argument of `reduce` is `0`, it _inferred_ that the
	reducer function’s first argument is `number`, and from that, it
	_inferred_ that the result of the `reduce` call, and so the function’s
	return type will be `number` too.
- because the type checker knows all of that, it will beep us if somehow
	try to multiply `item.price` with a string on a late Friday night…

This is both smart, and very helpful.

### Change

I find that the ability to change is the most important part of any
project. No mater how much we think upfront about what we think our code
should be, at some point we’ll need to change it. And at that point, the
type checker will point every place in the code that it knows it’ll be
affected by changing this function here. It will not let us doubt about
wether we found all the places where it’s used those hundreds of files
in our project.

## The superpower

No matter how smart an IDE can be, it can’t keep up with what the
compiler knows about he code, and this is why TypeScript can do all the
things above. It comes with a tool that has access to the same data and
language services that the compiler does: the
[tsserver](https://github.com/Microsoft/TypeScript/wiki/Standalone-Server-(tsserver))
that [can be
used](https://github.com/Microsoft/TypeScript/wiki/TypeScript-Editor-Support)
by IDEs and text editors to find things about the project source code.

Because it
[uses](https://github.com/Microsoft/TypeScript/wiki/Architectural-Overview)
the same core functionality as the compiler, it can unambiguously tell
things like:

- What type is this symbol?
- Where is this symbol declared?
- Where is this symbol used?
- What are the IntelliSense options for this thing here?
- What other places in the project would I have to change if I rename
	this symbol?

This is exactly what makes it possible to have fearless project-wide
refactorings with TypeScript.

## Outro

Every little piece of data that moves through our code has a specific
type. Wether we specify it explicitly or not, we are aware of it when we
write or change that function. If we explicitly define that type, the
type checker can help us keep the code in harmony with the data.

I find this somewhat similar to unit tests: We always want to test every
piece of code. The question is only wether we’ll do it manually or will
automate it.

### Two Links

- [The Docs®](https://www.typescriptlang.org/docs/tutorial.html)
- [The Book](https://basarat.gitbooks.io/typescript/)
