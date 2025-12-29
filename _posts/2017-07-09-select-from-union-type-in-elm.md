---
layout: post
title: Select from union type in Elm
date: 2017-07-09 16:55
tags: [elm, fp, patterns, web]
---
One of the things that attracted me early on in Elm were the [union
types](https://guide.elm-lang.org/types/union_types.html): Having the compiler
ensure that discrete values of a variable are correct seems quite useful. And it
was as disappointing when I couldn’t find out a _type-safe_ and reasonably
straightforward way to build a `<select>` tag out of a union type. I’m
emphasizing type-safe because Elm’s type system is the reason why I’m learning
it. Conceptually these two things — a union type and a dropdown — align
perfectly, and I thought it should be a way to code it as well.

It turns out that that’s not actually possible: The selected option lives in the
DOM, and so it’s a string. And now it’s up to my Elm application code to take
that value and map it to a member of the union type. That clarified, how do I do
that mapping in a reasonably elegant way?

I need a two-way mapping: from the union type’s members to DOM `<option>`s, and
back. The first thing that comes to mind is a couple of helper functions:
`toOptionString` and `fromOptionString`. For example:

```elm
module Currency exposing (Currency)

type Currency = USD | EUR | MDL

-- often this can be replaced with `toString`
toOptionString : Currency -> String
toOptionString currency =
  case currency of
    USD -> "US dollar"
    EUR -> "Euro"
    MDL -> "Moldovan leu"

fromOptionString : String -> Currency
fromOptionString string =
  case string of
    "US dollar" -> USD
    "Euro" -> EUR
    "Moldovan leu" -> MDL
    _ -> USD
```

This is readable code, and can totally
[work](https://ellie-app.com/3HD9NqtWsxKa1/1), but there are a couple of things
that don’t sit quite well with me:
1. every time I need to add a type member I have to touch 3 places;
2. and the “catch all” raises any Elm programmer’s eyebrow; …although if you
   think about it, it absolutely makes sense: I read input from the outside,
   and so it’s sensible have a default case.

While this works, I wasn’t totally satisfied and so I came up with another way
to look at it: Conceptually I want to implement a mapping between union type’s
members and some corresponding labels to show in the UI, and the simplest way to
get that in Elm is an array of tuples:

```elm
valuesWithLabels : List ( Currency, String )
valuesWithLabels =
  [ ( USD, "USD" )
  , ( EUR, "EUR" )
  , ( MDL, "MDL" )
  ]
```

Technically, this is all I need to build a reasonably type-safe `<select>` for
any union type, and here is the
[module](https://github.com/gurdiga/xo.elm/blob/ca2eca55dc0e771872bac4e406645bf4a1b819da/src/Widgets/Select.elm)
that came out of this thought experiment:

```elm
module Widgets.Select exposing (fromValuesWithLabels)

import Html exposing (Html, select, option, text)
import Html.Attributes exposing (selected)
import Html.Events exposing (onInput)


fromValuesWithLabels : List ( a, String ) -> a -> (a -> msg) -> Html msg
fromValuesWithLabels valuesWithLabels defaultValue callback =
    let
        optionForTuple ( value, label ) =
            option [ selected (defaultValue == value) ] [ text label ]

        options valuesWithLabels defaultValue =
            List.map optionForTuple valuesWithLabels

        maybeValueFromLabel l =
            List.filter (\( value, label ) -> label == l) valuesWithLabels
                |> List.head

        valueFromLabel label =
            case maybeValueFromLabel label of
                Nothing ->
                    defaultValue

                Just ( value, label ) ->
                    value
    in
        select
            [ onInput (callback << valueFromLabel) ]
            (options valuesWithLabels defaultValue)
```

It needs is:
* a list of tuples
* a default value
* a callback function

Now, when I change the union type, I only need to update the type definition and the list of tuples, which, although not ideal, it seems quite a workable solution. 8-)
