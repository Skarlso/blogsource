---
title: Minecraft Server with Docker on OSX + Mods
author: hannibal
layout: post
date: 2016-03-29
url: /2016/03/29/minecraft-server-with-docker-and-osx
categories:
  - Minecraft
---

Hi Folks.

Intro
=====

Today, I wanted to write about how to create a secure server in a container. Ideally, you don't want to run your server on your own machine. Running it in a container gives you a much needed control and an extra layer of security.

Docker On OSX
=============

While on a mac, you have a couple of options to run docker.

Docker-Machine
--------------

[Docker-Machine](https://docs.docker.com/machine/)

Docker machine is very simple. It just creates a Linux vm in the background on VirtualBox which can be managed through VirtualBox as well. Network, Memory, port-forwarding can all be managed through the VM directly. Then running and starting is trivial through ```docker-machine start```.

Boot2Docker
-----------

[Boot2Docker](http://boot2docker.io/)

Runs a tiny linux in which you can use Docker freely. This adds the benefit of not having to mess around with VirtualBox.

DLite
-----

[DLite](https://github.com/nlf/dlite)

DLite is the newest addition in the Game. Since docker uses /var/run/docker.sock file to communicate with the daemon, and this file is not there on OSX, DLite takes care of that. After DLite is running, you just simply use Docker. That's it. No VM, no fuss, just use Docker.

I recommend to use DLite, however, it's not an official tool yet, so for the sake of this guide, I'll be writing up a docker-machine oriented solution.

Docker container - A Vanilla Server
==================================

First, you need to setup a docker container. For this, use my [Dockerfile](https://github.com/Skarlso/devops/blob/master/minecraft/Dockerfile). The steps on how to setup this file are written down in the README file, located here => [Container Setup](https://github.com/Skarlso/devops/tree/master/minecraft).

This will download the Minecraft server version 1.9 and install java and vim and setup port forwarding. It uses /data as a shared folder. Data will also be the working directory. This server will be a vanilla server, meaning, no modding. The server is started from /data so the world will be located there. If you have a single player world, you just copy that here and rename it to world and that's it.

In order for this to work online, you'll have to setup the enclosing VM to forward 25565 to your local IP address.

With VirtualBox you'll find these settings under => Settings => Network => Adapter 1 => Advanced => PortForwarding. Here, setup something like this:
Name: Minecraft; Protocol: TCP; Host IP: 192.168.0.X(x=your local machine); Host Port: 25565; Guest IP: Leave Blank; Guest Port: 25565.

This should forward any ports coming from your VM to your local IP. In the container we have an expose and as the README states it's started using -p 25565:25565 which will make sure that from the container, 25565 is exposed to the VM. And from the VM 25565 is exposed to your local. Chain forwarding.

Docker container - Modding
==========================

If you are not looking for anything, just a simple server, the above will be enough. You can still do /tp 1 1 1 to teleport, or can still use bans and op commands. However, if you would like to use mods, and as far as kids are concerned, they will want it, you'll have to be a bit more clever.

I dug far and deep and found that you have two options. Either go with a forge server, or a bukkit server. What does that mean? The vanilla server of Minecraft does not support modding. Modding, is modifying the implementation of Minecraft. It injects code and runs a pre-server in front of the original Minecraft server in order to append functionality. But fret not, this is all taken care of for you by either solutions.

In order to jump into our container with the CMD, we'll have to run the following command instead of the one in the README.

~~~bash
docker run -it -v `pwd`:/data -p 25565:25565 --name mc_server minecraft:v1.9 bash
~~~

This will give you an interactive prompt in which now we can operate.

Forge
-----

Download the latest forge version from here => [Minecraft Forge](http://files.minecraftforge.net/). They are usually up-to-date. I'm using 1.9 so I downloaded the appropriate installer version. After I obtained it, it was a matter of running this piece of command line code from my container:

~~~bash
java -jar forge-1.9-12.16.0.1813-1.9-installer.jar --extract --installServer
~~~

This will unpack a bunch of things you don't have to worry about. Now run the universal.

~~~bash
java -jar forge-1.9-12.16.0.1813-1.9-universal.jar
~~~

Everything under the **mods** folder will be loaded as a mod. Forge is very restrictive and can only use Forge based mods. You can find these on Forge's forum here: [Forge Forum](http://www.minecraftforge.net/forum/index.php/board,30.0.html).

Bukkit
------

I found bukkit to be the winner for me. Most the mods I wanted worked with bukkit and did not work with Forge. Others will sware on Forge, but it's really up to you. Using bukkit is similarly easy. Again, you'll have to find and get the wrapper which can be located here: [GetSpigot](http://getspigot.org/). You can use Spigot as well, though I have no experience with that.

Once, you got the wrapper which is called ```craftbukkit-1.9.jar``` for me, you run it the same way you would run Forge or Minecraft.

~~~bash
java -jar craftbukkit-1.9.jar
~~~

This will load mods from the **plugins** folder. Plugins can be found here: [Latest Bukkit Plugins](http://mods.curse.com/bukkit-plugins/minecraft/new).

Just download the jar and copy them into your shared docker container folder's plugin folder. Which should be /data in the container.

Last Words
==========

All in all this sounds complicated but it's actually not once you'll get the hang out of it. You never kill the container once it's setup, you just do ```docker stop mc_server``` and then ```docker-machine stop``` if you want to stop the VM as well.

That's it. Hope this was clear. Any feedback is appreciated. If you think you have an easier way, or if I wrote something incorrectly, feel free to tell me in the comments.

Thanks for reading.

Gergely.
