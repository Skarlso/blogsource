+++
author = "hannibal"
categories = ["kubernetes"]
date = "2019-09-25T21:01:00+01:00"
type = "post"
title = "Using a Kubernetes based Cluster for Various Services with auto HTTPS - Part 2"
url = "/2019/09/25/kubernetes-cluster-part2"
comments = true
draft = true
+++

# Intro

Hi folks.

This is a continuation of the previous post about my Kubernetes infrastructure. The two remaining points are to deploy Athens Go proxy and setting up monitoring.

# Athens

@TODO: Create Drawing of Athens.

Let's start with [Athens](https://github.com/gomods/athens).

First of all if you are a helm user, I have to note that Athens has an awesome set of helm charts which you can use to deploy it in your cluster.
Located [here](https://github.com/gomods/athens/tree/master/charts/athens-proxy).

I prefer the deploy my own charts, I don't really like helm. But that's me. So here is my preferred way of deploying Athens.

First, since this is also a subdomain of the previously created