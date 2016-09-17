---
title: Budget Home Theather with a Headless Raspberry Pi and Flirc for Remote Controlling
author: hannibal
layout: post
date: 2016-09-17
url: /2016/09/17/simple-hometheater-with-remote-and-flirc
categories:
  - Hardware
---

Intro
------

Hello folks.

Today, I would like to tell you about my configuration for a low budget Home Theater setup.

My tools are as follows:
* [FLIRC](https://flirc.tv/)
* [Raspberry Pi 2](https://www.raspberrypi.org/products/raspberry-pi-2-model-b/)
* 500G SSD
* An a good 'ol wifi

TL;DR
------

Use Flirc for remote control, `omxplayer` for streaming the movie from an SSD on a headless PI controller via SSH and enjoy a nice, cold Lemon - Menta beer.

Flirc
------

First, the remote control. So, I like to sit in my couch and watch the movie from there. I hate getting up, or having a keyboard at arm length to control the pi. Flirc is a very easy way of doing just that with a simple remote control.

It costs ~$22 and is easy to setup. Works with any kind of remote control. Setting up key bindings for the control, is as simple as starting the Flirc software and pressing buttons. Now, my pi is running headless, and the Flirc binary isn't quite working with a pi; so to do the binding, I just did that on my main machine. After I bound some key combinations to my remote, I proceeded to setup the pi.

Raspberry Pi 2
----------------

The pi 2 is a small powerhouse. However, the SD card on which it sits is simply not fast enough to be able to handle large files properly. So, instead of coping the movie to the pi, I'm streaming through the pi from a faster SSD. For streaming, I'm using `omxplayer`. With omxplayer, I had a few problems, because sound was not coming through the HDMI cable. After a little bit of research I found that, for starters, you need to change a setting in the pi's boot config. Namely, uncomment this line:

~~~bash
#hdmi_driver=2
~~~

After rebooting, I also, did this thing:

~~~bash
sudo apt-get install alsa-utils
sudo modprobe snd_bcm2835
sudo amixer -c 0 cset numid=3 2
~~~

This saved my bacon. The whole answer can be found here: [Stackoverflow](http://raspberrypi.stackexchange.com/questions/44/why-is-my-audio-sound-output-not-working).

Moving on, all I had to do is just run this command: `omxplayer -o hdmi -r /media/stream/my_movie.mkv`. This used the local HDMI connection to play my movie from a mounting point where I was streaming my movie through.

All this was from my computer through an SSH session so I never controlled the pi directly. Once done, I proceeded to sit down with a nice, cold Lemon - Menta beer and a remote control. Now, `omxplayer` is controlled through the buttons + (volume up), - (volume down), <SPACE> (stop, play), and q for quitting. Flirc is able to map any key combination on a keyboard to any button on the remote. Combinations can be done by selecting a control key and pressing another key. That will be registered as a key combination. So mapping `+` to the volume up button was by pressing shift and then '='.

Wrapping Up
------------

I enjoyed the movie while being able to adjust the volume, or pause it, when my popcorn was ready, and close the player when the movie was done.

There you have it folks. Home theater on the budget.

Cheers,
Gergely.
