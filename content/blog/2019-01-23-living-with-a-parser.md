+++
author = "hannibal"
categories = ["ruby", "parser"]
date = "2019-01-23T08:01:00+01:00"
type = "post"
title = "Living with a new Parser for a year"
url = "/2019/01/23/living-with-a-parser"
description = "Living with a Parser"
featured = "parser.png"
featuredalt = "parser"
featuredpath = "date"
linktitle = ""
draft = true
+++

Hi folks!

Today's post is a retrospective of some kind. I would like to gather some thoughts about living with the new parser that I wrote previously here: ...

Now, after little over a year, some interesting problems surfaced that I thought I'd share for people who also would like to endevour on this path. Let's begin.

# Replacing Eval

As I wrote previously, the parser is there to replace eval. The eval was meant to only execute comparisons and such, not the whole ruby language. And thus, I wrote the parser by minimising the complexity of the things that it would have to parse.

As such, I didn't had to write a whole AST or a language parser, just a subset of it.