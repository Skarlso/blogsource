+++
author = "hannibal"
categories = ["Golang", "Furnace"]
date = "2018-09-18T07:01:00+01:00"
type = "post"
title = "HashiCorp go-plugin tutorial"
url = "/2018/09/18/go-plugin-tutorial"
description = "HashiCorp Go-plugin tutorial"
featured = "plugin-tutorial.png"
featuredalt = "plugin"
featuredpath = "date"
linktitle = ""
draft = true
+++

Hi.

Today we are going to explore the plugin system of HashiCorp called [go-plugin](http://github.com/hashicorp/go-plugin).

Let's get to it then.

# Intro

If you don't know what go-plugin is, don't worry. I'll give a small introduction on the subject matter.

Back in the old days when go didn't have the `plugin` package, HashiCorp was desperatly looking for a way to use plugins in Go.

In the old days, Lua plus Go wasn't really a thing yet, and to be honest, nobody wants to write Lua ( joking! ).

And thus Mitchell had this brilliant idea of using RPC over the local network to server a local interface as something that
could easily be implemented with any other language that supported RPC. This sounds convoluted but has the benefit that plugins
will never crash your system, as I already mentioned, it also gives the plugin author the opportunity of using ANY language. And
not just Go to write a plugin.

This has been battle prooven for years, since Terraform, Vault, Consule and especially Packer are all using go-plugin in order to
provide a much needed flexibility for these tools. Writing a plugin is easy. Or so they say.

It can get pretty complicated quickly if you are trying to use GRPC for example. You can loose sight of what exactly you'll
need to implement and where and why? Or, utilizing various languages or using go-plugins in your own project and extending your
CLI with pluggable components.

These are all nothing to sneeze at. They can quickly become complicated and you suddenly find yourself with hundreds of lines of
code pasted from various examples and suddenly nothing works. Or worse, it DOES work, but you have no idea how or why? And find
yourself that you need to extend it with a new capability or find an ellusive bug and can't trace it's origins.

But fear not. I'll try to demistify things and draw a good picture about how this works and {where,how} the pieces fit together.

Let's start at the beginning. I'm going to use GRPC in these examples.

# Basic plugin

Let's start by writing a simple Go GRPC plugin. In fact we can go through the Basic example in the go-plugin repository which can
be quiet confusing when you first start out. But we'll go step by step and the switch to GRPC will be easier.


