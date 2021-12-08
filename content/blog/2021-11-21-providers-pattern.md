+++
author = "hannibal"
categories = ["books"]
date = "2021-11-21T01:01:00+01:00"
type = "post"
title = "Providers Pattern"
url = "/2021/11/21/providers-pattern"
comments = true
draft = true
+++

Hello Dear readers.

Today, I would like to write about a project design pattern I've been using successfully over the past years for
various projects. It has many variations and it has some design patterns that are commonly found in the wild, so there
is nothing really special about it.

Let's begin.

# Providers Pattern

What is this pattern anyways? It's a pattern I learned while working at [ArangoDB](https://www.arangodb.com/). It's
quite nice and defines package abstractions wonderfully. It somewhat resembles the Repository pattern from DDD and also
uses Chain of Responsibility to setup multiple providers for a given functionality. Like a fallback, in case a Provider
does not understand the current thing it got. In that case, it will delegate to `Next`.

I'm going to demonstrate all of the pattern's capabilities through a sample project which is hopefully a sensible thing
and not just dummy functionality.

## TL;DR

A Provider is like the [Repository pattern](https://martinfowler.com/eaaCatalog/repository.html) from DDD combined with
[Chain Of Responsibility](https://en.wikipedia.org/wiki/Chain-of-responsibility_pattern). Basically, set up a Provider
using an `interface` as a definition. Give that as dependency to another provider and call it's function. If the
Provider doesn't understand the type its supposed to work on, it will call `Next` in the chain delegating the function
to the following Provider. For a detailed use of this pattern, check out
[Providers Example](https://github.com/Skarlso/providers-example) project on GitHub.

## The Project

[Providers Example](https://github.com/Skarlso/providers-example) is the project I'll be using to demonstrate this
pattern. It's pretty simple; yet, I hope, it presents a useful function to be show off this pattern's capabilities.

In essence, this is a plugin executor. We have a CLI which can register plugins to execute. These plugins can either be
bare metal (as in give it a URL of a tarred up binary and it will download it), or a docker container, in which case it
will use Docker to execute the plugin. It will forward all possible parameters and display any outputs.

Simple, yet there are a couple things that we can extract into Providers such as:

1. Dealing with the archive ( so we can test the Tar function )
2. Selecting the executing environment ( bare metal, container ) which we can chain
3. Output formatting ( possibly, thing like, JSON, Table, etc. )
4. Saving things into a Database ( we will save what kind of plugins exist using sqlite )
    4.1. We'll just save the name and the type for simplicity

## Basics

Let's take a look at the folder structure here.

## Dependency Injection

## Testability

## Chaining Providers

## Conclusions

And as always,
Thanks for reading,
Gergely.
