+++
author = "hannibal"
categories = ["devops", "java", "Linux"]
date = "2015-06-06"
type = "post"
tags = ["docker", "gocd", "vagrant"]
title = "Docker + Java + Vagrant+ GO.CD"
url = "/2015/06/06/docker-ruby-lotus-go-cd/"

+++

Hello folks.

Today, I would like to write about something interesting and close to me at the moment. I&#8217;m going to setup Go.cd with Docker, and I&#8217;m going to get a Ruby Lotus app running. Let&#8217;s get started.

<!--more-->

# Fluff

Now, obviously, you don&#8217;t really need Go.Cd or Docker to setup a Java Gradle application, since it&#8217;s dead easy. But I&#8217;m going to do it just for the heck of it.

# Setup

Okay, lets start with Vagrant. Docker&#8217;s strength is coming from Linux&#8217;s process isolation capabilities it&#8217;s not yet properly working on OSX or Windows. You have a couple of options if you&#8217;d like to try never the less, like boot2docker, or a Tiny Linux kernel, but at that point, I think it&#8217;s easier to use a VM.

#### Vagrant

So, let&#8217;s start with my small Vagrantfile.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="ruby" style="font-family:monospace;"><span style="color:#008000; font-style:italic;"># -*- mode: ruby -*-</span>
<span style="color:#008000; font-style:italic;"># vi: set ft=ruby :</span>
&nbsp;
<span style="color:#008000; font-style:italic;"># All Vagrant configuration is done below. The "2" in Vagrant.configure</span>
<span style="color:#008000; font-style:italic;"># configures the configuration version (we support older styles for</span>
<span style="color:#008000; font-style:italic;"># backwards compatibility). Please don't change it unless you know what</span>
<span style="color:#008000; font-style:italic;"># you're doing.</span>
Vagrant.<span style="color:#9900CC;">configure</span><span style="color:#006600; font-weight:bold;">&#40;</span><span style="color:#006666;">2</span><span style="color:#006600; font-weight:bold;">&#41;</span> <span style="color:#9966CC; font-weight:bold;">do</span> <span style="color:#006600; font-weight:bold;">|</span>config<span style="color:#006600; font-weight:bold;">|</span>
  <span style="color:#008000; font-style:italic;"># The most common configuration options are documented and commented below.</span>
  <span style="color:#008000; font-style:italic;"># For a complete reference, please see the online documentation at</span>
  <span style="color:#008000; font-style:italic;"># https://docs.vagrantup.com.</span>
&nbsp;
  <span style="color:#008000; font-style:italic;"># Every Vagrant development environment requires a box. You can search for</span>
  <span style="color:#008000; font-style:italic;"># boxes at https://atlas.hashicorp.com/search.</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">box</span> = <span style="color:#996600;">"trusty"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">box_url</span> = <span style="color:#996600;">"https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">network</span> <span style="color:#996600;">"forwarded_port"</span>, guest: <span style="color:#006666;">2300</span>, host: <span style="color:#006666;">2300</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">network</span> <span style="color:#996600;">"forwarded_port"</span>, guest: <span style="color:#006666;">8153</span>, host: <span style="color:#006666;">8153</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">provision</span> <span style="color:#996600;">"shell"</span>, path: <span style="color:#996600;">"setup.sh"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">provider</span> <span style="color:#996600;">"virtualbox"</span> <span style="color:#9966CC; font-weight:bold;">do</span> <span style="color:#006600; font-weight:bold;">|</span>v<span style="color:#006600; font-weight:bold;">|</span>
    v.<span style="color:#9900CC;">memory</span> = <span style="color:#006666;">8192</span>
    v.<span style="color:#9900CC;">cpus</span> = <span style="color:#006666;">2</span>
  <span style="color:#9966CC; font-weight:bold;">end</span>
<span style="color:#9966CC; font-weight:bold;">end</span></pre>
      </td>
    </tr>
  </table>
</div>

Very simple. I&#8217;m setting up a trusty64(because docker requires 3.10 <= x) box and then doing a simple shell provision. Also, I gave it a bit juice, since go-server requires a raw power. Here is the shell script:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">!</span><span style="color: #666666; font-style: italic;">#/bin/bash</span>
<span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get update</span>
<span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> <span style="color: #660033;">-y</span> software-properties-common python-software-properties
<span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get update</span>
<span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> <span style="color: #660033;">-y</span> <span style="color: #c20cb9; font-weight: bold;">vim</span>
<span style="color: #c20cb9; font-weight: bold;">sudo</span> add-apt-repository <span style="color: #660033;">-y</span> <span style="color: #ff0000;">"ppa:webupd8team/java"</span>
<span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get update</span>
<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #c20cb9; font-weight: bold;">debconf</span> shared<span style="color: #000000; font-weight: bold;">/</span>accepted-oracle-license-v1-<span style="color: #000000;">1</span> <span style="color: #000000; font-weight: bold;">select</span> <span style="color: #c20cb9; font-weight: bold;">true</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">sudo</span> debconf-set-selections <span style="color: #000000; font-weight: bold;">&</span>amp;<span style="color: #000000; font-weight: bold;">&</span>amp; <span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #c20cb9; font-weight: bold;">debconf</span> shared<span style="color: #000000; font-weight: bold;">/</span>accepted-oracle-license-v1-<span style="color: #000000;">1</span> seen <span style="color: #c20cb9; font-weight: bold;">true</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">sudo</span> debconf-set-selections
<span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> <span style="color: #660033;">-y</span> oracle-java8-installer
<span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get update</span>
<span style="color: #c20cb9; font-weight: bold;">wget</span> <span style="color: #660033;">-qO-</span> https:<span style="color: #000000; font-weight: bold;">//</span>get.docker.com<span style="color: #000000; font-weight: bold;">/</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">sh</span>
route add <span style="color: #660033;">-net</span> 172.17.0.0 netmask 255.255.255.0 gw 172.17.42.1</pre>
      </td>
    </tr>
  </table>
</div>

The debconf at the end accepts java8&#8217;s terms and conditions. And the last line installs docker in my box. This runs for a little while&#8230;

The routing on the end routes every traffic from 172.17.\*.\* to my vagrant box, which in turn I&#8217;ll be able to use from my mac local, like 127.0.0.1:8153/go/home.

After a vagrant up, my box is ready to be used.

#### Docker

When that&#8217;s finished, we can move on to the next part, which is writing a little Dockerfile for our image. Go.cd will require java and a couple of other things, so let&#8217;s automate the installation of that so we don&#8217;t have to do it by hand.

Here is a Dockerfile I came up with:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">FROM ubuntu
MAINTAINER Skarlso
&nbsp;
<span style="color: #666666; font-style: italic;">############ SETUP #############</span>
RUN <span style="color: #c20cb9; font-weight: bold;">apt-get update</span>
RUN <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> <span style="color: #660033;">-y</span> software-properties-common python-software-properties
RUN add-apt-repository <span style="color: #660033;">-y</span> <span style="color: #ff0000;">"ppa:webupd8team/java"</span>
RUN <span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #c20cb9; font-weight: bold;">debconf</span> shared<span style="color: #000000; font-weight: bold;">/</span>accepted-oracle-license-v1-<span style="color: #000000;">1</span> <span style="color: #000000; font-weight: bold;">select</span> <span style="color: #c20cb9; font-weight: bold;">true</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">sudo</span> debconf-set-selections <span style="color: #000000; font-weight: bold;">&</span>amp;<span style="color: #000000; font-weight: bold;">&</span>amp; <span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #c20cb9; font-weight: bold;">debconf</span> shared<span style="color: #000000; font-weight: bold;">/</span>accepted-oracle-license-v1-<span style="color: #000000;">1</span> seen <span style="color: #c20cb9; font-weight: bold;">true</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">sudo</span> debconf-set-selections
RUN <span style="color: #c20cb9; font-weight: bold;">apt-get update</span>
RUN <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> <span style="color: #660033;">-y</span> oracle-java8-installer
RUN <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> <span style="color: #660033;">-y</span> <span style="color: #c20cb9; font-weight: bold;">vim</span>
RUN <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> <span style="color: #660033;">-y</span> <span style="color: #c20cb9; font-weight: bold;">unzip</span>
RUN <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> <span style="color: #660033;">-y</span> <span style="color: #c20cb9; font-weight: bold;">git</span></pre>
      </td>
    </tr>
  </table>
</div>

So, our docker images have to be setup with Java as well for go.cd which I&#8217;m taking care of here, and a little bit extra, to add vim, and unzip, which is required for dpkg later.

At this point run: **docker build -t ubuntu:go .** -> This will use the dockerfile and create the ubuntu:go image. Note the **. **at the end.

#### Go.cd

Now, I&#8217;m creating two containers. One, go-server, will be the go server, and the other, go-agent, will be the go agent.

First, go-server:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">docker run <span style="color: #660033;">-i</span> <span style="color: #660033;">-t</span> <span style="color: #660033;">--name</span> go-server <span style="color: #660033;">--hostname</span>=go-server <span style="color: #660033;">-p</span> <span style="color: #000000;">8153</span>:<span style="color: #000000;">8153</span> ubuntu:go <span style="color: #000000; font-weight: bold;">/</span>bin<span style="color: #000000; font-weight: bold;">/</span><span style="color: #c20cb9; font-weight: bold;">bash</span>
<span style="color: #c20cb9; font-weight: bold;">wget</span> http:<span style="color: #000000; font-weight: bold;">//</span>download.go.cd<span style="color: #000000; font-weight: bold;">/</span>gocd-deb<span style="color: #000000; font-weight: bold;">/</span>go-server-15.1.0-<span style="color: #000000;">1863</span>.deb
<span style="color: #c20cb9; font-weight: bold;">dpkg</span> <span style="color: #660033;">-i</span> go-server-15.1.0-<span style="color: #000000;">1863</span>.deb</pre>
      </td>
    </tr>
  </table>
</div>

Pretty straight forward, no? We forward 8153 to vagrant (which forwards it to my mac), so after we start go-server service we should be able to visit: http://127.0.0.1:8153/go/home.

Lo&#8217;, and behold, go server. Let&#8217;s add an agent too.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">docker run <span style="color: #660033;">-i</span> <span style="color: #660033;">-t</span> <span style="color: #660033;">--name</span> go-agent <span style="color: #660033;">--hostname</span>=go-agent ubuntu:go <span style="color: #000000; font-weight: bold;">/</span>bin<span style="color: #000000; font-weight: bold;">/</span><span style="color: #c20cb9; font-weight: bold;">bash</span>
<span style="color: #c20cb9; font-weight: bold;">wget</span> http:<span style="color: #000000; font-weight: bold;">//</span>download.go.cd<span style="color: #000000; font-weight: bold;">/</span>gocd-deb<span style="color: #000000; font-weight: bold;">/</span>go-agent-15.1.0-<span style="color: #000000;">1863</span>.deb
<span style="color: #c20cb9; font-weight: bold;">dpkg</span> <span style="color: #660033;">-i</span> go-agent-15.1.0-<span style="color: #000000;">1863</span>.deb
<span style="color: #c20cb9; font-weight: bold;">vim</span> <span style="color: #000000; font-weight: bold;">/</span>etc<span style="color: #000000; font-weight: bold;">/</span>default<span style="color: #000000; font-weight: bold;">/</span>go-agent
<span style="color: #007800;">GO_SERVER</span>=172.17.0.1
service go-agent start</pre>
      </td>
    </tr>
  </table>
</div>

No need to forward anything here. And as you can see, my agent was added successfully.

All nice, and dandy. The agent is there, and I enabled it, so it&#8217;s ready to work. Let&#8217;s give it something to do, shall we?

# The App

I&#8217;m going to use my gradle project which is on github. This one => https://github.com/Skarlso/DataMung.git.

Very basic setup. Just check it out and then build & run tests. Easy, right?

First step in this process, define the pipeline. I&#8217;m going to keep it simple. Name the pipeline DataMunger. Group is Linux. Now, in go.cd you have to define something called, an **environment**. Environment can be anything you want, I&#8217;m going to go with Linux. You have to assign **agents** to this environment who fulfil it and the pipeline which will use that environment. More on that you can read in the go.cd documentation. This is how you would handle a pipeline which uses linux, and a windows environment at the same time.

In step one you have to define something called the **Material**. That will be the source on which the agent will work. This can be multiple, in different folders within the confines of the pipeline, or singular.

I defined my git project and tested the connection OK. Next up is the first **Stage **and the initial **Job **to perform. This, for me, will be a compile or an assemble, and later on a test run.

Now, Go is awesome in parallelising jobs. If my project would be large enough, I could have multiple jobs here. But for now, I&#8217;ll use stages because they run subsequently. So, first stage, compile. Next stage, testing and archiving the results.

I added the next stage and defined the artefact. Go supports test-reports. If you define the path to a test artefact than go will parse it and create a nice report out of it.

Now, let&#8217;s run it. It will probably fail on something. 😉

Well, I&#8217;ll be&#8230; It worked on the first run.

And here are the test results.

# Wrap-up

Well, that&#8217;s it folks. Gradle project, with vagrant, docker, and go.cd. I hope you all enjoyed reading about it as much as I did doing it.

Any questions, please feel free to ask it in the comment section below.

Cheers,
Have a nice weekend,
Gergely.
