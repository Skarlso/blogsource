+++
author = "hannibal"
categories = ["Linux"]
date = "2012-04-11"
type = "post"
tags = ["additional", "bumblebee", "drivers", "graphics", "linux", "nvidia", "nvidia-current", "resolution", "ubuntu", "ubuntu 12.04", "xrandr"]
title = "Getting Dual Card to work on Ubuntu 12.04."
url = "/2012/04/11/getting-dual-card-to-work-on-ubuntu-12-04/"

+++

Hi guys. 

Today I want to talk about a little adventure I had yesterday night. It was quite the fun and frustration too. But neither comes without the other when it&#8217;s about linux. 

So let us see what the problem is at hand. The problem machine is a Dell Inspiron N5110 with Nvidia card number one: GeForce GT 525M. And number two: Integrated. Optimus for the win. 

So how windows is handling this is actually with a software called Optimus. Now linux wasn&#8217;t design to handle this properly but there are solutions. But I&#8217;m getting ahead of myself. Let&#8217;s start with the install.

**Ubuntu Install**

So first of all I installed <a href="http://www.ubuntu.com/download/ubuntu/download" target="_blank">Ubuntu 32 bit</a> because I experienced more problems with 64 bit. To be honest the ubuntu page also recommends 32 bit. You don&#8217;t get to much from the 64 any ways. 

After I downloaded and burned my disc and installed ubuntu next to my windows 7, I went for the updates. Now HERE is the first key point in my struggle. After the install I went for the additional drivers listed. There were actually additional drivers listed at that point!! Which is interesting because AFTER I installed the updates they disappeared and never appeared again. I&#8217;m guessing that one of the packages overrode my drivers. I would go back and reinstall the thing and experiment with it, but I don&#8217;t care any more. 

So let&#8217;s move on&#8230;

**After updating&#8230;**

So update went on and my Ubuntu was not using the proper resolution for my screen. It was stuck on 1024&#215;768. Now at this point I would say I could have played around with xrandr and cvt but more about that later&#8230; 

I was immediately searching for additional drivers only to find that my list was empty&#8230; 

![Empty Additional Drivers][1]

Like this. Now this isn&#8217;t something new actually. I had this one before and I could not for the life of me solve it. Let&#8217;s see what I did. 

**Common in Every solution**
  
First let&#8217;s go over some repository updates I did before starting to get some solutions.

I added the x-swat repository to apt-get because that has the most recent packages that will be released. 

Add it with these commands:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
2
3
4
</pre>
      </td>
      
      <td class="code">
        <pre class="bash" style="font-family:monospace;">    <span style="color: #666666; font-style: italic;">#Add swat repository</span>
    <span style="color: #c20cb9; font-weight: bold;">sudo</span> add-apt-repository ppa:ubuntu-x-swat<span style="color: #000000; font-weight: bold;">/</span>x-updates
    <span style="color: #666666; font-style: italic;">#Update and upgrade</span>
    <span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get update</span> <span style="color: #000000; font-weight: bold;">&&</span> <span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get upgrade</span></pre>
      </td>
    </tr>
  </table>
</div>

Now you&#8217;re ready to move on&#8230; 

**Solution Fail Number One**

My first guess was to reinstall nvidia driver because of the updates the new driver has to be built with the new version of kernel. 

So what I did was:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
</pre>
      </td>
      
      <td class="code">
        <pre class="bash" style="font-family:monospace;">    <span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get remove</span> <span style="color: #660033;">--purge</span> nvidia-current</pre>
      </td>
    </tr>
  </table>
</div>

After that finished I reinstalled everything:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
</pre>
      </td>
      
      <td class="code">
        <pre class="bash" style="font-family:monospace;">    <span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get update</span> <span style="color: #000000; font-weight: bold;">&&</span> <span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> nvidia-current nvidia-settings</pre>
      </td>
    </tr>
  </table>
</div>

Additional drivers sometimes needs update to get new drivers. After that I rebooted. At this point I didn&#8217;t have an xorg.conf files yet. 

After the reboot everything was the same. Nothing changed. nvidia-settings still said I don&#8217;t appear to be using nvidia x. All right I thought let&#8217;s do that. 

So I run:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
</pre>
      </td>
      
      <td class="code">
        <pre class="bash" style="font-family:monospace;">    <span style="color: #c20cb9; font-weight: bold;">sudo</span> nvidia-xconfig</pre>
      </td>
    </tr>
  </table>
</div>

And reboot..

Now THIS messed up my resolution pretty badly. All I was able to get my desktop to was 640&#215;480. At this point I begun to play with xrandr. 

**Xrandr**

So in order to get my resolution back I started to play around with xrandr at the first place. I wasn&#8217;t trying to add anything to xorg.conf yet because I needed to find out if it would even work! 

Now xrandr adds unsupported resolutions to video cards. If you have a resolution which us unknown you can set it using cvt. 

Here is an article how to do so: <a href="https://wiki.ubuntu.com/X/Config/Resolution" target="_blank">Xrandr</a>

Alas this didn&#8217;t work&#8230; LVDS1 which was the display for my laptop didn&#8217;t wanted to allow the new resolution I added for 1366&#215;768. The error was:

X Error of failed request: BadMatch (invalid parameter attributes)
    
Major opcode of failed request: 150 (RANDR)
    
Minor opcode of failed request: 18 (RRAddOutputMode)
    
Serial number of failed request: 25
    
Current serial number in output stream: 26

I couldn&#8217;t make much of this rather then that my card was still not properly configured and additional drivers was still empty. 

As back to square one. I deleted xorg.conf and begun another solution.

**Solution Fail Number Two**

As I was going through problems I found one interesting one. It was a guide on how to install downloaded nvidia driver from scratch. 

So again I went and uninstalled nvidia and started this solution. The steps are these:

1. Start ubuntu with recovery mode. Login in root shell (with networking)
  
2. Remove your nvidia driver(what you did install) maybe this can be help: sudo apt-get purge nvidia-current sudo rm -rf /etc/X11/xorg.conf
  
3. restart your computer: sudo reboot
  
4. start ubuntu normally (not recovery)
  
5. open /etc/default/grub : sudo gedit /etc/default/grub
  
6. replace the line GRUB\_CMDLINE\_LINUX=&#8221;&#8221; to GRUB\_CMDLINE\_LINUX=&#8221;nomodeset&#8221; (save and exit)
  
7. update grub: sudo update-grub
  
8. Download appropriate driver from nvidia
  
10.Give executable permission to the downloaded file : chmod a+x nvidia_driver.run
  
11. Press CLT+ALT+F1 [command line shell will appear] and login
  
12. stop lightdm (display manager) service : sudo service lightdm stop
  
13. start nvidia installation: sudo ./nvidia_driver.run
  
14. reboot your system: sudo reboot

Now this brought up a couple of new problems. First that although I downloaded the proper driver from Nvidia it failed to detect my GPU for whatever reasons. And second it could not build because it couldn&#8217;t find nvidia.ko. I couldn&#8217;t resolve these issues although I guess there are some for it. But in the end it didn&#8217;t matter. 

I reverted back to my original state&#8230; which was removing all of the drivers and resetting grub to its original state and went on to solution number three&#8230;

**Working Solution Number Three**

At this point I just wanted SOMETHING to work. I didn&#8217;t even care about my nvidia card any more. And that was when I came across a post about dual cards. Something I didn&#8217;t care about because IT WAS WORKING before the UPDATE! But I want on any ways and that was the right solution in the end. 

You can find this solution <a href="http://askubuntu.com/questions/120261/ubuntu-11-10-problem-with-nvidia/120600#comment143754_120600" target="_blank">here</a>. The first answer.

For my sanities sake I will write it down here too.

**First**
  
Remove nvidia drivers&#8230; Again.

**Second**
  
Reinstall Mesa package for GL:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
</pre>
      </td>
      
      <td class="code">
        <pre class="bash" style="font-family:monospace;">    <span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get</span> <span style="color: #660033;">--reinstall</span> <span style="color: #c20cb9; font-weight: bold;">install</span> libgl1-mesa-glx</pre>
      </td>
    </tr>
  </table>
</div>

This will get your first card to work with ubuntu.

At this point I reinstalled my nvidia drivers too&#8230; Something the other guy didn&#8217;t mention.

**Third**
  
Reboot

**Fourth**
  
Install a program called bumblebee. Yes, <a href="http://bumblebee-project.org/install.html" target="_blank">Bumblebee</a>

This is equal to Windows optimus. It will handle your dual video cards. You&#8217;ll see in a moment how.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
2
3
</pre>
      </td>
      
      <td class="code">
        <pre class="bash" style="font-family:monospace;">    <span style="color: #c20cb9; font-weight: bold;">sudo</span> add-apt-repository ppa:bumblebee<span style="color: #000000; font-weight: bold;">/</span>stable
    <span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get update</span>
    <span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> bumblebee bumblebee-nvidia</pre>
      </td>
    </tr>
  </table>
</div>

**Fifth**
  
Add yourself to use Bumblebee:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
</pre>
      </td>
      
      <td class="code">
        <pre class="bash" style="font-family:monospace;">    <span style="color: #c20cb9; font-weight: bold;">sudo</span> usermod <span style="color: #660033;">-a</span> <span style="color: #660033;">-G</span> bumblebee <span style="color: #007800;">$USER</span></pre>
      </td>
    </tr>
  </table>
</div>

And then comes the magic. So in order for you to be able to use your second card with bumblebee you have to execute the program with optirun. This is much like windows optimus, just optimus works in the background. 

After this I could finally see my cards settings for example by typing in:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
</pre>
      </td>
      
      <td class="code">
        <pre class="bash" style="font-family:monospace;">    <span style="color: #c20cb9; font-weight: bold;">sudo</span> optirun nvidia-settings <span style="color: #660033;">-c</span> :<span style="color: #000000;">8</span></pre>
      </td>
    </tr>
  </table>
</div>

This executed the settings app and I was able to edit some settings I required while ubuntu was running fine with my other video card as primary card.

Now that was quite the fun, like I said, not? 

I hope this guide showed you my errors and problems and maybe it could help you get along with yours. 

If you have any questions, please feel free to write. 

Thanks for reading!

 [1]: http://ielmira.com/uploads/gallery/album_114/gallery_635_114_12692.png
