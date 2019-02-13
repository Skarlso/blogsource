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

Next, came supported operations. The parser only supported the basic operators: `<>=`. It was missing `=~` from this. Which meant people who would use regexes to filter JSON would no longer be able to do so. This was only a tiny modification actually:

First, the operator filter needed to be aware...
~~~ruby
- elsif t = scanner.scan(/(\s+)?[<>=][=<>]?(\s+)?/)
+ elsif t = scanner.scan(/(\s+)?[<>=][=~]?(\s+)?/)
~~~

With that done, we just `.to_regexp` it with the power of ruby and `send` would automatically pick it up. And of course test coverage.

# Regression

Once the parser was introduced I knew that it would create problems. Since eval did many things that the parser could not handle. And they started to arrive slowly. One-by-one.

## Boolean

Aka, the story of how `true == 'true'` doesn't work...

## Syntax

## Number formatting

# Groups

And finally, the biggest one... Groups in conditions. A query like this one for example:

~~~
$..book[?((@['author'] == 'Evelyn Waugh' || @['author'] == 'Herman Melville' && (@['price'] == 33 || @['price'] == 9))]
~~~

Something like this was never parsed correctly. Since the parser didn't understand groupping and order of evaluation. Let's break it down. How do we get from a monstrum like that one above to something that can be handled? We take it one group at a time.

## Parentheses

As a first step, we make sure that the parentheses match. It's possible that someone didn't pay attention and left out a closing parentheses. Now, there are a couple of way of doing that in Ruby, but I went for the most plain blatant one.

~~~ruby
    def check_parenthesis_count(exp)
      return true unless exp.include?("(")
      depth = 0
      exp.chars.each do |c|
        if c == '('
          depth += 1
        elsif c == ')'
          depth -= 1
        end
      end
      depth == 0
    end
~~~

A basic depth counter. We do this first, to avoid parsing an invalid query.

## Breaking it down

Next we break down this complex thing into a query that makes more sense to the parser. To do that, we take each group and extract the operation in them and replace it with the value they provide. Meaning a query like the one above essentially should looke like this:

~~~
((false || false) && (false || true))
~~~

Neat. This is handled by this code segment: [Parser](https://github.com/joshbuddy/jsonpath/blob/b2525b8e8c596ddf1c8b40982529300b5a98132b/lib/jsonpath/parser.rb#L112).

The parsing function is called over and over again until there are no parentheses left in the expression. Aka, a single true or false or number remains.

Now, who can spot an issue with that? The function `bool_or_exp` is there to return a float or a boolean value. If it returns a float, we still &&= -it together with the result... Thus, if there is a query like this one for example:

~~~
$..book[?(@.length-5 && @.type == 'asdf')]
~~~

This would fail horribly. Which means, asking for a specific index in a json in a groupped expression is not supported at the moment.

## Return Value

The parser doesn't just return a bool value and call it a day. It also returns indexes like you read above. Indexes in cases when there is a query that returns the location of an item in the node and not if the node contains something or matches some data. For example:

~~~
$..book[(@.length-5)]
~~~

Returns the length-5-th book.

# Outstanding issues

Right now there are two outstanding issues. The one mentioned above, where you can't nest indexes and true/false notations. And the other is a submitted issue in which it is described that it's not possible to use something like this:

~~~
$.phoneNumbers[?(@[0].type == 'home')]
~~~

Which basically boils down to the fact that Jsonpath can't handle nested lists like these:

~~~json
{
  "phoneNumbers": [
    [{
      "type"  : "iPhone",
      "number": "0123-4567-8888"
    }],
    [{
      "type"  : "home",
      "number": "0123-4567-8910"
    }]
  ]
}
~~~

But that isn't actually the problem of the parser, but Jsonpath itself.
