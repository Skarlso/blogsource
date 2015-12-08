---
title: Kill a Program on Connecting to a specific WiFi – OSX
author: hannibal
layout: post
date: 2015-10-26
url: /2015/10/26/kill-a-program-on-connecting-to-a-specific-wifi-osx/
categories:
  - devops
  - problem solving
tags:
  - launchd
  - osx
---
Hi folks. 

If you have the tendency, like me, to forget that you are on the corporate VPN, or leave a certain software open when you bring your laptop to work, this might be helpful to you too. 

It&#8217;s a small script which kills a program when you change your Wifi network.

Script:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666; font-style: italic;">#!/bin/bash</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">function</span> log <span style="color: #7a0874; font-weight: bold;">&#123;</span>
    <span style="color: #007800;">directory</span>=<span style="color: #ff0000;">"/Users/&lt;username&gt;/wifi_detect"</span>
    <span style="color: #007800;">log_dir_exists</span>=<span style="color: #c20cb9; font-weight: bold;">true</span>
    <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #000000; font-weight: bold;">!</span> <span style="color: #660033;">-d</span> <span style="color: #007800;">$directory</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
        <span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"Attempting to create =&gt; <span style="color: #007800;">$directory</span>"</span>
        <span style="color: #c20cb9; font-weight: bold;">mkdir</span> <span style="color: #660033;">-p</span> <span style="color: #007800;">$directory</span>
        <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #000000; font-weight: bold;">!</span> <span style="color: #660033;">-d</span> <span style="color: #007800;">$directory</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
            <span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"Could not create directory. Continue to log to echo."</span>
            <span style="color: #007800;">log_dir_exists</span>=<span style="color: #c20cb9; font-weight: bold;">false</span>
        <span style="color: #000000; font-weight: bold;">fi</span>
    <span style="color: #000000; font-weight: bold;">fi</span>
    <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #007800;">$log_dir_exists</span> ; <span style="color: #000000; font-weight: bold;">then</span>
        <span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"<span style="color: #007800;">$(date)</span>:$1"</span> <span style="color: #000000; font-weight: bold;">&gt;&gt;</span> <span style="color: #ff0000;">"<span style="color: #007800;">$directory</span>/log.txt"</span>
    <span style="color: #000000; font-weight: bold;">else</span>
        <span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"<span style="color: #007800;">$(date)</span>:$1"</span>
    <span style="color: #000000; font-weight: bold;">fi</span>
<span style="color: #7a0874; font-weight: bold;">&#125;</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">function</span> check_program <span style="color: #7a0874; font-weight: bold;">&#123;</span>
    <span style="color: #007800;">to_kill</span>=<span style="color: #ff0000;">"[<span style="color: #007800;">${1::1}</span>]<span style="color: #007800;">${1:1}</span>"</span>
    log <span style="color: #ff0000;">"Checking if <span style="color: #007800;">$to_kill</span> really quit."</span>
    <span style="color: #007800;">ps</span>=$<span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #c20cb9; font-weight: bold;">ps</span> aux <span style="color: #000000; font-weight: bold;">|</span><span style="color: #c20cb9; font-weight: bold;">grep</span> <span style="color: #ff0000;">"<span style="color: #007800;">$to_kill</span>"</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>
    log <span style="color: #ff0000;">"ps =&gt; <span style="color: #007800;">$ps</span>"</span>
    <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #660033;">-z</span> <span style="color: #ff0000;">"<span style="color: #007800;">$ps</span>"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
	<span style="color: #666666; font-style: italic;"># 0 - True</span>
        <span style="color: #7a0874; font-weight: bold;">return</span> <span style="color: #000000;"></span>
    <span style="color: #000000; font-weight: bold;">else</span>
	<span style="color: #666666; font-style: italic;"># 1 - False</span>
        <span style="color: #7a0874; font-weight: bold;">return</span> <span style="color: #000000;">1</span>
    <span style="color: #000000; font-weight: bold;">fi</span>
<span style="color: #7a0874; font-weight: bold;">&#125;</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">function</span> kill_program <span style="color: #7a0874; font-weight: bold;">&#123;</span>
    log <span style="color: #ff0000;">"Killing program"</span>
    <span style="color: #000000; font-weight: bold;">`</span>pkill <span style="color: #660033;">-f</span> <span style="color: #ff0000;">"$1"</span><span style="color: #000000; font-weight: bold;">`</span>
    <span style="color: #c20cb9; font-weight: bold;">sleep</span> <span style="color: #000000;">1</span>
    <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #000000; font-weight: bold;">!</span> check_program <span style="color: #007800;">$1</span> ; <span style="color: #000000; font-weight: bold;">then</span>
	log <span style="color: #ff0000;">"$1 Did not quit!"</span>
    <span style="color: #000000; font-weight: bold;">else</span>
	log <span style="color: #ff0000;">"$1 quit successfully"</span>
    <span style="color: #000000; font-weight: bold;">fi</span>
<span style="color: #7a0874; font-weight: bold;">&#125;</span>
&nbsp;
<span style="color: #007800;">wifi_name</span>=$<span style="color: #7a0874; font-weight: bold;">&#40;</span>networksetup <span style="color: #660033;">-getairportnetwork</span> en0 <span style="color: #000000; font-weight: bold;">|</span><span style="color: #c20cb9; font-weight: bold;">awk</span> <span style="color: #660033;">-F</span><span style="color: #ff0000;">": "</span> <span style="color: #ff0000;">'{print $2}'</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>
log <span style="color: #ff0000;">"Wifi name: <span style="color: #007800;">$wifi_name</span>"</span>
<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #ff0000;">"<span style="color: #007800;">$wifi_name</span>"</span> = <span style="color: #ff0000;">"&lt;wifi_name&gt;"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
    log <span style="color: #ff0000;">"On corporate network... Killing Program"</span>
    kill_program <span style="color: #ff0000;">"&lt;programname&gt;"</span>
<span style="color: #000000; font-weight: bold;">elif</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #ff0000;">"<span style="color: #007800;">$wifi_name</span>"</span> = <span style="color: #ff0000;">"&lt;home_wifi_name&gt;"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
    <span style="color: #666666; font-style: italic;"># Kill &lt;program&gt; if enabled and if on &lt;home_wifi&gt; and if Tunnelblick is running.</span>
    log <span style="color: #ff0000;">"Not on corporate network... Killing &lt;program&gt; if Tunnelblick is active."</span>
    <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #000000; font-weight: bold;">!</span> check_program <span style="color: #ff0000;">"Tunnelblick"</span> ; <span style="color: #000000; font-weight: bold;">then</span>
	log <span style="color: #ff0000;">"Tunnelblick is active. Killing &lt;program&gt;"</span>
	kill_program <span style="color: #ff0000;">"&lt;program&gt;"</span>
    <span style="color: #000000; font-weight: bold;">else</span>
	log <span style="color: #ff0000;">"All good... Happy coding."</span>
    <span style="color: #000000; font-weight: bold;">fi</span>
<span style="color: #000000; font-weight: bold;">else</span>
    log <span style="color: #ff0000;">"No known Network..."</span>
<span style="color: #000000; font-weight: bold;">fi</span></pre>
      </td>
    </tr>
  </table>
</div>

Now, the trick is, on OSX to only trigger this when your network changes. For this, you can have a &#8216;launchd&#8217; daemon, which is configured to watch three files which relate to a network being changed. 

The script sits under your ~/Library/LaunchAgents folder. Create something like, com.username.checknetwork.plist.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="xml" style="font-family:monospace;"><span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;?xml</span> <span style="color: #000066;">version</span>=<span style="color: #ff0000;">"1.0"</span> <span style="color: #000066;">encoding</span>=<span style="color: #ff0000;">"UTF-8"</span><span style="color: #000000; font-weight: bold;">?&gt;</span></span>
<span style="color: #00bbdd;">&lt;!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" \</span>
<span style="color: #00bbdd;"> "http://www.apple.com/DTDs/PropertyList-1.0.dtd"&gt;</span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;plist</span> <span style="color: #000066;">version</span>=<span style="color: #ff0000;">"1.0"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;dict<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>Label<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>ifup.ddns<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
&nbsp;
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>LowPriorityIO<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;true</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
&nbsp;
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>ProgramArguments<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;array<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>/Users/username/scripts/ddns-update.sh<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/array<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
&nbsp;
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>WatchPaths<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;array<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>/etc/resolv.conf<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>/Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/string<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/array<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
&nbsp;
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>RunAtLoad<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/key<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;true</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/dict<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/plist<span style="color: #000000; font-weight: bold;">&gt;</span></span></span></pre>
      </td>
    </tr>
  </table>
</div>

Now, when you change your network, to whatever your corporate network is, you&#8217;ll kill Sublime.

Hope this helps somebody.
  
Cheers,
  
Gergely.