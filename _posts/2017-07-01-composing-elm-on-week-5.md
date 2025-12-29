---
layout: post
title: Composing Elm on week 5
date: 2017-07-01 19:28
tags: []
---
A few weeks ago I have set out to try Elm on [a toy project of
mine](https://github.com/gurdiga/xo.elm). The experience was like learning to
program again: I had to figure out very basic things like how to attach
an event handler to a field.

One of the main thing that I try to figure out early in the process of learning
any new language is how do I break the code into smaller files as the code gets
larger, and then, how do I wire the pieces back together. Once I learn this,
I can grow the app. …And, as sad as it may sound, although I begun by reading
the [Official Elm Guide®](https://guide.elm-lang.org/), the
[documentation](http://elm-lang.org/docs) on the site, and [a good
book](https://www.manning.com/books/elm-in-action), I was still not very clear
on how to do that. :-/

The approach to scaling [described](https://guide.elm-lang.org/reuse/) in the
guide, seems a bit vague to me:

> […] it just works differently in Elm. **We do not think in terms of reusable
> components**. Instead, we focus on reusable functions.

…and for now there was not an official example project where the code is split
into multiple files as it would be the case in any non-hello-world project. Even
[the todo-mvc sample
project](https://github.com/evancz/elm-todomvc/blob/master/Todo.elm) is a single
file.

As a side-note, although I’ve heard it’s not idiomatic to use the word
“component” with Elm, I think this still remains a useful concept in the
conversation about building UIs because it’s a well understood term and it fits
the visual outcome.  For example if I’m talking about a text field, it seems more
natural to call it a component and point to it on the screen, than to call it
a view helper function.

My difficulty was mainly related to messages and event handlers. For the
simplest of forms you need an `onInput` event handler to collect the data, and
in most examples the way to get that is to define a _message_ and then use it
with the event handler. For example:

```
type alias Model =
    { fieldValue : String }


type Msg
    = UpdateField String -- ← This is the message


update : Msg -> Model -> Model
update msg model =
    case Msg of
        UpdateField value ->
            { model | fieldValue = value }


view : Model -> Html Msg
view =
    input [ onInput UpdateField ] []
```

When the messages and the view functions are all in one file, that’s easy, but
how do I now extract some of the pieces so that they live in their own file for
reuse other places of my app? The module system in Elm [is
quite nice](https://guide.elm-lang.org/reuse/modules.html), so there is no
difficulty in the extracting process itself, but now I have to
figure out what exactly do I extract and how it’d all come back together.

Extracting view functions is easy: they’re only functions. But I tended to think
that, generally speaking, it’s goo to have them live together with the types
and data structures that those functions display. Having
them together will make it easier to work with them and keep them in sync. So
a component’s file usually has these pieces:

1. the type;
2. the `newValue` function that returns an empty value of that type;
3. the `view` function that receives a value of that type, and a callback that
   receives the updated value as the user changes it.

One example is a Person component:

```
module Person exposing (Person, newValue, view)

import Html exposing (Html, ul, li)
import Widgets.Fields exposing (textField, largeTextField)


type alias Person =
    { firstName : String
    , lastName : String
    , address: String
    }


newValue : Person
newValue =
    { firstName = ""
    , lastName = ""
    , address = ""
    }


view : Person -> (Person -> msg) -> Html msg
view p callback =
    ul []
        [ li [] [ textField "First name:" p.firstName (\v -> callback { p | firstName = v }) ]
        , li [] [ textField "Last name:" p.lastName (\v -> callback { p | lastName = v }) ]
        , li [] [ largeTextField "Address:" p.address (\v -> callback { p | address = v }) ]
        ]
```

If a client module has a value of this type to display, it would reuse this
component’s pieces like this:

```
import Person exposing (Person)


type alias Contract =
    { person : Person -- ← Here the client uses the imported type
    , notes : String
    }


newValue : Contract
newValue =
    { person = Person.newValue -- ← Here the client uses the `newValue` helper function
    , notes = ""
    }


view : Contract -> (Contract -> msg) -> Html msg
view contract callback =
    fieldset []
        [ legend [] [ text "Legend" ] -- ↙ Here the client uses the `view` function
        , Person.view contract.person (\v -> callback {contract | person = v})
        , textField "Notes:" person.notes (\v -> callback { contract | notes = v })
        ]
```

So `Person.view` receives the value of type `Person` and a callback, and renders
the UI for that value. And when user changes the value, `Person.view` the
callback will receive the updated version.

The neat part of this approach is that it can be easily nested. The `Contract`
module has a similar structure: the type, the `newValue` function, and the
`view` function, and can be used in a similar way in other places in the app.

While [at the very
top](https://github.com/gurdiga/xo.elm/blob/91d5fd1644ba051adf0226c8f70bcd49f0dcee28/src/Main.elm#L43-L54)
of the component hierarchy I still have an `update` function and messages, the
domain-concept-based components have this public API:

1. the type
2. the `newValue` function
3. the `view` function

This is the approach I’m using after 5 weeks into the project, and I like it.
8-)
