---
layout: post
title: My today’s view on code
date: '2015-06-28T01:15:02+03:00'
tags: [dev]
categories: []
---
This morning I have finished watching a course on Frontend Masters. It’s
called “[Hardcore Functional Programming in
JavaScript](https://frontendmasters.com/courses/functional-javascript/).”
Functional programming (FP) is interesting to me. It’s partly because I
hear people speaking very passionately about it. It’s like an exotic
thing that I don’t completely understand, but I’m curious to find out
what it is.

A few months ago I have watched [a Haskell
course](https://www.pluralsight.com/courses/haskell-fundamentals-part1).
Haskell seems to be the reference language when it comes to FP. Lisp is
another reference FP language. And I have read the
[SICP](https://mitpress.mit.edu/sicp/full-text/book/book.html)
introductory course that uses Scheme — a dialect of Lisp. Then I have
read another book on Common Lisp. I still have a [Lisp
blog](http://www.lispcast.com/) in my Feedly.

I found Haskell hard. Lisp felt more approachable. I liked the
simplicity of Scheme. In SICP I have recognized things that I use in JS:
dynamic typing, closures, lexical scope, and first-class functions. I
guess because of these common features there are many FP libraries
written in JS.

My curiosity grew even more when I heard [Uncle Bob promoting
Clojure](https://skillsmatter.com/skillscasts/2323-bobs-last-language).
He explains that FP languages are becoming more relevant now because
computers have more and more CPU cores. And because of that the ability
to build programs that run on multiple cores is more important. He says
that FP languages seem to fit better parallel work because they [favor
immutability](http://clojure.org/about/functional_programming#_immutable_data_structures).

I didn’t apply neither Haskell nor Lisp. But, after this last video
course I think I understand better functors and monads. I also realize
that the more I understand them, the less they are attractive. I think
it’s because they introduce too many new concepts. Category Theory seems
to be [an important part of the
FP](http://cs.stackexchange.com/questions/3028/is-category-theory-useful-for-learning-functional-programming)
and this intimidates me. It is too much conceptual overhead.

Understanding a domain and modeling its concepts in a programming
language is already hard, and introducing another conceptual layer makes
it even harder.

I like it when program components reflects domain concepts. I like it
when I look into a piece of code and I see the domain.

For example, a domain can be website. It’s composed of pages. Pages are
composed of forms, links, and other UI widgets. When the code reflects
these concepts — page, form, link, widget — it’s easier to understand.
And when it’s easier to understand, it’s easier to adapt and grow along
with the business that it supports.

I guess there is value in immutability and type systems, and I do find
some of the FP idioms to be practical. But it’s more valuable to be able
to look at a codebase and see what it does and how it relates to the
business that it was built for.
