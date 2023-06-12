---
layout: post
title: My JS enum type
date: '2015-10-03T18:54:44+03:00'
tags: [js]
categories: []
---
For my `PersonSection` widget I needed to have a `PERSON_TYPES` constant.

```js
var PERSON_TYPES = ['juridică', 'fizică'];
```

This turned out handy when building the
[`SelectField`](https://github.com/gurdiga/xo/blob/a7e5b2d9d7c03724fdd048d44b7cca963fafd028/app/widgets/PersonSection.js#L89)
that’ll let the user pick any of the two options.

And then in some other place I had an if/else that was supposed to
display a different set of fields depending on the option selected, so I
needed something like this:

```js
if (selectedOption === ???)
```

So now I had the option to either use the string:

```js
if (selectedOption === 'juridică')
```

or,

```js
if (selectedOption === PERSON_TYPES[0])
```

I didn’t like either of them, so I decided to add to the `PERSON_TYPES`
array one property per option to hold the value and still have it as a
constant to use elsewhere in the code:

```js
PERSON_TYPES.COMPANY = 'juridică';
PERSON_TYPES.INDIVIDUAL = 'fizică';
```

so now I can say

```js
if (personType === PERSON_TYPES.INDIVIDUAL) //
```

Looks good here, but now I had this:

```js
var COMPANY = 'juridică';
var INDIVIDUAL = 'fizică';
var PERSON_TYPES = [COMPANY, INDIVIDUAL];
PERSON_TYPES.COMPANY = COMPANY;
PERSON_TYPES.INDIVIDUAL = INDIVIDUAL;
```

which wasn’t intention-revealing so I packed it into a function:

```js
// somewhere at the top
var PERSON_TYPES = definePersonTypes();

// more code

// somewhere at the bottom
function definePersonTypes() {
  var COMPANY = 'juridică';
  var INDIVIDUAL = 'fizică';

  var types = [COMPANY, INDIVIDUAL];
  types.COMPANY = COMPANY;
  types.INDIVIDUAL = INDIVIDUAL;

  return types;
}
```

This worked. But later I got to the `CaseSubjectSection` widget and I
needed a similar thing for `SUBJECT_TYPES` so I extracted a utility
function:

```js
function createHashArray(hash) {
  var array = _.values(hash);

  _.each(hash, function(v, k) {
    array[k] = v;
  });

  return array;
}

var PERSON_TYPES = createHashArray({
  COMPANY: 'juridică',
  INDIVIDUAL: 'fizică'
});
```

The `createHashArray` name didn’t sound right. I squinted at it a little
bit and looked a bit like enum types, so I renamed it to
`createEnumArray`. Still not perfect, but I think it reveals enough of
the intent.

Later when writing unit tests the `deepEqual` was surprisingly failing
here:

```js
t.deepEqual(createdEnum, ['juridică', 'fizică'], 'the array has the appropriate items');
```

I didn’d check the source code for `deepEqual` but my guess was that
it’s picking on the `COMPANY` and `INDIVIDUAL` properties on the
`PERSON_TYPES` array, which are not on the vanilla `selectOptionLabels`.
I tried to transform them both to strings with `.join(',')` and then do
the assertion based on that. It worked but it was making the test harder
to understand.

To get around this, I made the properties non-enumerable by using
[`Object.defineProperty`](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty)
instead of `array[k] = v`, and now I have this:

```js
function createEnumArray(hash) {
  var array = _.values(hash);

  _.each(hash, function(v, k) {
    Object.defineProperty(array, k, {
      value: v,
      enumerable: false
    });
  });

  return array;
}

var PERSON_TYPES = createEnumArray({
  COMPANY: 'juridică',
  INDIVIDUAL: 'fizică'
});
```

It’s a little more verbose, but it gives me a cleaner test, and I accept
it.
