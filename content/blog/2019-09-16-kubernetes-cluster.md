+++
author = "hannibal"
categories = ["kubernetes"]
date = "2019-09-16T21:01:00+01:00"
type = "post"
title = "Using a Kubernetes based Cluster for Various Services with auto HTTPS"
url = "/2019/09/16/kubernetes-cluster"
draft = true
comments = true
+++

# Intro

Hi folks.

Today, I would like to show you how my infrastructure is deployed and managed. Spoiler alert, I'm using Kubernetes to do that.

I know... What a twist!

Let's get to it.

# What

What services am I running exactly? Here is the exact list of services I'm running at the time of writing:

@TODO: Insert graphic here, about the deployment of various services with their respective logos.

- Athens Go Proxy
- Gitea
- The Lounge (IRC bouncer)
- Two CronJobs
    - Fork Updater
    - IDLE RPG online checker
- My WebSite (gergelybrautigam.com)
- Monitoring

And it's really simple to add more.

# Where

My cluster is deployed at DigitalOcean using two droplets each 1vCPU and 2GB RAM.

@TODO: Small image of DO + Kube

# What Not

This isn't going to be a production grade cluster. What I don't include in here:

@TODO: Danger Zone sign

## RBAC for various services and users

Since I'm the only user of my cluster I didn't create any kind of access limits / users or such. You are free to create them though. The only role based auth that's going on is for Prometheus.

I'm not using any third party things which require access to the API.

## Resource limitation

I'm the sole user of my things. I'm not really scaling my gitea up or down based on usage and as such, I did not define things like:

- Resource limits
- Nodes with certain capabilities
- Affinities and Taints -- everything can run everywhere

# How

Okay, with that out of the way, let's get into the hows of things...

# Beginning

The most important thing that you need to do in order to use Kubernetes is Containerizing all the things.

@TODO: Drawing -- Container in all the things, like cats, dogs... etc.

Since Kubernetes is a container orchestration tool, without containers it's pretty useless.

As a driver, I'm going to use Docker. Kubernetes can use anything that's OCI compatible, which means if you would like to use runc as a container engine, you can do that. I'd like to keep my sanity though.

## Example

@TODO: Insert a cool little drawing about the fork updater.

To show you what I mean... I have a cronjob which is running every month. It gathers all my forks on github and updates them with the latest from their parents. This a small ruby script located here: [Fork Updater](https://gist.github.com/Skarlso/fd5bd5971a78a5fa9760b31683de690e). How do we run this? It requires two things. First, a token. We pass that currently as an environment property. It could be in a file in a vault or a secret mounted in as a file it doesn't matter. Currently, it's an environment property. The second thing is more subtle.

I'm pushing the changes back into my remote forks. I'm doing this via SSH. So, we need a key in there too. How we'll get that in there, I'll talk about later when we are talking about how to set this cron job up. For now though, the container needs to look for a key in a specific location. Because we don't want to over-mount `/root/.ssh/` and we also don't want to use an initContainer to copy over an SSH key (because it's mounted in as a symlink (but that's a different issue all together)).

To achieve this, we simply set up a `config` file for SSH like this one:

```
Host github.com
    IdentityFile /etc/secret/id_rsa
```

`/etc/secret` will be the destination of the ssh key we create.

And we also need to have a known_hosts file, otherwise git clone will complain. We also bake this into the container. Why? Why not generate that on the fly? Because I want it to fail in case there is something wrong or there is a MIMA going on etc.

All this translated into a Dockerfile looks like this:

```Dockerfile
# We are using alpine for a minimalistic image
FROM alpine:latest

RUN apk --no-cache add ca-certificates
RUN apk update
# Openssh is needed for the SSH command
RUN apk --no-cache add ruby vim curl git build-base ruby-dev openssh openssh-client

# Setup dependencies for the fork ruby file
RUN gem install octokit logger multi_json json --no-ri --no-rdoc

RUN mkdir /data
WORKDIR /data
# Setup some data about the committer
RUN git config --global user.name "Fork Updater"
RUN git config --global user.email "email@email.com"
RUN mkdir -p /root/.ssh
# Get the host config for github.com
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# Setup the SSH config
COPY ./config /root/.ssh
COPY ./fork_updater.rb .
CMD ["ruby", "/data/fork_updater.rb"]
```

That's it. Now our updater is containerized and ready to be deployed as a cronjob on a kube cluster.

# Before we Begin

There are two things we will need though to set up for our cluster before we even begin adding the first service. And that's an ingress with a load-balancer and cert-manager.

# Cert-Manager

Now, you have the option of installing cert-manager via helm, or via the provided kube config yaml file. I **STRONGLY** recommend using the config yaml file because the upgrading process with helm is a hell of a lot dirtier / failure prone than simply applying a new yaml file with a different version in it.

Either way, to install cert-manager follow this simple guide: [Cert-manager Install Manual](https://docs.cert-manager.io/en/latest/getting-started/install/kubernetes.html#installing-with-regular-manifests).

# Ingress

An Ingress is a must. This is the component which manages external access to the services which we will define. Like a proxy before your http server. This component will handle the hostname based routing between our services.

I'm using nginx ingress, although there are a couple of implementations out there.

To install nginx ingress, follow their guide here: [Installing Nginx-Ingress](https://kubernetes.github.io/ingress-nginx/deploy/).

# From Easy to Complicated

Alright. Now that we have the prereqs out of the way, let's get our hands dirty. I'll start with the easiest of them all, my web site, and then will progress towards the more complicated ones, like Gitea and Athens, which require a lot more fiddling and have more moving parts.

## My Website

The site, located here: [Gergely's Domain](gergelybrautigam.com); is a really simple, static, [Hugo](https://gohugo.io) based website. It contains nothing fancy, no real Javascript magic, has a simple list of things I've done and who I am.

It's powered / served by an nginx instance running on port 9090 define by a very simple Dockerfile:

```Dockerfile
FROM golang:latest as builder
RUN apt-get update && apt install -y git make vim hugo
RUN mkdir -p /opt/website
RUN git clone https://github.com/Skarlso/gergelybrautigam /opt/website
WORKDIR /opt/website
RUN make

FROM nginx:latest
RUN mkdir -p /var/www/html/gergelybrautigam
WORKDIR /var/www/html/gergelybrautigam
COPY --from=builder /opt/website/public .
COPY 01_gergelybrautigam /etc/nginx/sites-available/
RUN mkdir -p /etc/nginx/sites-enabled/
RUN ln -s /etc/nginx/sites-available/01_gergelybrautigam /etc/nginx/sites-enabled/01_gergelybrautigam
```

Easy as goblin pie. Nginx has a command set like this `CMD ["nginx", "-g", "daemon off;"]` and exposes port 80.

### The deployment

In order to deploy this in the cluster, I created a deployment as follows:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gb-deployment
  namespace: gergely-brautigam
  labels:
    app: gergelybrautigam
  annotations:
      prometheus.io/scrape: 'true'
      prometheus.io/port:   '9090'
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gergelybrautigam
  template:
    metadata:
      labels:
        app: gergelybrautigam
      annotations:
          prometheus.io/scrape: 'true'
          prometheus.io/port:   '9090'
    spec:
      containers:
      - name: gergelybrautigam
        image: skarlso/gergelybrautigam:v0.0.26
        ports:
        - containerPort: 9090
```

What is going on here? Really simple. The metadata section defines information about the deployment. It's name is gb-deployment. The namespace in which this sits is called gergely-brautigam and it has some labels to it so our routing can find it later on.

It's running a single replica, has a bunch of more metadata and template settings, and finally the container spec which defines the image, and the exposed container port on which the application is running.

Now we need a service to expose this deployment.

### The service

The service is also simple. It looks like this:

```yaml
kind: Service
apiVersion: v1
metadata:
  namespace: gergely-brautigam
  name: gb-service
spec:
  selector:
    app: gergelybrautigam
  ports:
  - port: 80
    targetPort: 9090
```

Again, nothing fancy here, just a simple service exposing a port to a different port on the front-end side. This service will be picked up by our previously created routing facility.

@TODO: Insert image here on the architecture.

### Ingress

Now that we have the service we need to expose it to the domain. I have the domain gergelybrautigam.com and I already pointed it at the LoadBalancer's IP which was created by the nginx ingress controller.

We only want one LoadBalancer, but we have multiple hostnames. We can achieve that by creating an Ingress resource in the namespace our service is in like this: