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

# Metric Usage

What does it mean if the package is stable vs. unstable? Let's take a closer look.

## Unstable

If the instability metrics comes out as 1 or close to 1, that means that the package is unstable. That means that there are only packages that this package is depending upon and nothing or only 1 or 2 packages depend on this package. This means two things:

* The package is easy to change since there is nothing depending on the behavior explicitly
* The package is volatile since it depends on a lot of out side things

The first one is self-explanatory. The second one has ramifications. These ramifications are that there are a lot of packages that could cause bugs in this package. Ideally, a package with instability 1 or high, requires a large test coverage to ensure that changes in the out-side packages don't cause bugs.

## Stable

On the other spectrum lies the indicator for a stable package. If this metric is 0 or close to 0, the package is said to be stable. A stable package resists change because it has a lot of depending packages. The depending packages lock this package in place, meaning we can't change the package easily. Ideally this is the package that would contain our business logic which does not change often.

# Appliance in Go ecosystem

The book was using mostly Java for examples and dealt with classes describing these metrics. Especially the Abstractness of a package which calculates as ratio of abstract classes + interfaces vs concrete classes and implementations. This isn't that easy to define in Go. Not impossible though and we could still get something close enough.

The easier of these is the coupling metrics. I think we can define them since Go also has import statements. Go doesn't have classes, but I think it's enough if we calculate the number of packages that said package depends upon and are depended by. Should be close enough.

# Tool

If there is a project with a **lot** of packages and files it would be quite difficult to calculate these using your hands... Hence, [Effrit](https://github.com/Skarlso/effrit). This tool, at the writing of this post, only calculates the stability metric for now. If given a parameter like `-p effrit` it will only calculate the Fan-Out metrics considering project packages. If no project name is given, it will also calculate not project packages as Efferent.

How does it look like? Like this:

![furnace-before-tool](img/effrit/effrit1.png).

What do these means?

This means, that hopefully, `command` packages have a high coverage and that `config` packages don't require change that often.

# Conclusion

Hopefully this is an interesting metric to use to define what packages may need refactoring, or need to be repurposed because they are too rigid. If a packages is stable, aka. hard to change but must undergo changes frequently, it may be time to refactor and introduce a mediator or a liaison package to factor out what is changes frequently. This is called the Dependency Inversion Principle, DIP. Which is also described in the same book.

In fact these principles are called [SAP](http://wiki.c2.com/?StableAbstractionsPrinciple), [SDP](https://www.smartics.eu/confluence/display/ADOC/Stable+Dependencies+Principle). Stable Abstraction Principle and Stable Dependencies Principle. These are also described in the same book, Clean Architecture. Applying these principles could help maintain the project's stability and help maintain it's dependencies.

Thank you for reading,
Gergely.
