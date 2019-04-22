+++
author = "hannibal"
categories = ["go", "golang", "tools"]
date = "2019-04-25T08:01:00+01:00"
type = "post"
title = "Efferent and Afferent metrics in Go"
url = "/2019/04/25/efferent-and-afferent-metrics-in-go"
draft = true
comments = true
+++

# Intro

Hi folks!

Today I would like to talk to you about a metric that I read in the book called Clean Architecture from Robert Cecil Martin ( Uncle Bob ).

# Abstract

The metrics I mean are [Efferent](https://en.wikipedia.org/wiki/Software_package_metrics) and [Afferent](https://en.wikipedia.org/wiki/Software_package_metrics) coupling in packages. So you, dear reader, don't have to navigate away from this page, here are the descriptions pasted in:

- Afferent couplings (Ca): The number of classes in other packages that depend upon classes within the package is an indicator of the package's responsibility. Afferent couplings signal inward. (Affected by this package) (Fan-In).

- Efferent couplings (Ce): The number of classes in other packages that the classes in this package depend upon is an indicator of the package's dependence on externalities. Efferent couplings signal outward. (Effecting this package) (Fan-Out).

These metrics used together will indicate the stability / instability of each package in a project.

# Implementation

# Tool

# Conclusion

Thank you for reading,

Gergely.
