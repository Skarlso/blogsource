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

# Previously

About, almost two years ago, I took over managing / fixing / improving this ruby gem: [Json Parser](https://github.com/joshbuddy/jsonpath). It's a json parser in ruby. It was really poorly managed and maintained but the worst part of it was that it used `eval` in the background. It was a security rist to use this gem to it's full extent. Something had to be done about it.

I proceeded to write a semi-language parser which replaced eval which can be found here: [Parser](https://github.com/joshbuddy/jsonpath/blob/master/lib/jsonpath/parser.rb). The basic intention was to replace the basics of the eval behaviour, thus it was lacking some serious logic. That got put into it as time went by.

This is a one year retrospect on living with a self-written parser. Enjoy some of the quirks I faced while writing it.

# AST

AST is short for [Abstract Syntax Tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree). It's a datastructure that is ideal for representing and parsing language syntax. All major lexers use some kind of AST in the background like this old Ruby language parser gem: [Whitequark Parser](https://github.com/whitequark/parser). This parser is used by projects like Rubocop and line coverage reports and various others. It's applicate is not trivial right out of the box. But as you move along you get a firm grasp of it's power.

I decided to not use that parser a year ago mainly because I thought it's too much for what I'm trying to replace. Maybe I was right, maybe not. I tried to apply an AST with Parser recently. Maybe the next post will be how to apply it to a complex parser where there needs to be an evaluation output.

# The first problems

What was then the first trouble that arrose after I replaced eval? The parser back then was dumbed down a lot. The very first problem I faced was a simple infinite loop. The parser works like a simple lexer. It identifies tokens of certain type and tries to parse them into variables. This lexing had an error.

~~~ruby
-        elsif t = scanner.scan(/(\s+)?'?(\w+)?[.,]?(\w+)?'?(\s+)?/) # @TODO: At this point I should trim somewhere...
+        elsif t = scanner.scan(/(\s+)?'?.*'?(\s+)?/)
~~~

This error was caught by this Json Path:

~~~
$.acceptNewTasks.[?(@.taskEndpoint == "mps/awesome")].lastTaskPollTime
~~~

It was the `/` character that caused the problem. The tokenizer wasn't prepared...

Eval would have no problem but the parser is using strict regex-s. This is where an AST would have had more luck.

# Numbers

The second problem was the fact that the parser is using strings. Who would have thought that the string `2.0` in fact does not equal to string `2`? In Ruby the simplest way of making sure a variable is a Float is by casting the variable to Float. In case it's not a Float we rescue and move on.

~~~ruby
el = Float(el) rescue el
~~~

Incidentally this also solved the problem where the json path contained a number but since everything is a string this, also did not equal: `'1' == 1`.

Since first the string needed to be an Integer more videly a Number.

# Supporting regexes

Next, came supported operations. The parser at first only supported these operators `<>=`. Eval, supported all of them of course. But what else is there you might ask? `=~` for example.