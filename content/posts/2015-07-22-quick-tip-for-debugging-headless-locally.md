---
title: Quick Tip for Debugging Headless Locally
author: hannibal
layout: post
date: 2015-07-22
url: /2015/07/22/quick-tip-for-debugging-headless-locally/
categories:
  - problem solving
  - rambling
tags:
  - Packer
  - vagrant
---
If you are installing something with Packer and you have Headless enabled(and you are lazy and don&#8217;t want to switch it off), it gets difficult, to see output. 

Especially on a windows install the Answer File / Unattended install can be like => Waiting for SSH&#8230; for about an hour or two! If you are doing this locally fret not. Just start VirtualBox, and watch the Preview section which will display the current state even if it&#8217;s a headless install!

It&#8217;s a small windows, but your can click on **Show** which will open the VM in a proper view.

[<img src="http://ramblingsofaswtester.com/wp-content/uploads/2015/07/Screenshot-from-2015-07-22-152235-150x150.png" alt="Screenshot from 2015-07-22 15:22:35" width="150" height="150" class="alignnone size-thumbnail wp-image-574" />][1]

Enjoy,
  
Gergely.

 [1]: http://ramblingsofaswtester.com/wp-content/uploads/2015/07/Screenshot-from-2015-07-22-152235.png