---
title: Setting up a new Laptop with Puppet
author: hannibal
layout: post
date: 2015-05-21
url: /2015/05/21/setting-up-a-new-laptop-with-puppet/
categories:
  - devops
tags:
  - puppet
---
Hello folks.

So, some of you know <a href="https://puppetlabs.com/" target="_blank">puppet</a>, some of you don&#8217;t. Puppet is a configuration management system. It&#8217;s quite awesome. I like working with it. One of the benefits of puppet is, that I never, ever, EVER have to setup a new laptop from scratch, EVER again.

I&#8217;m writing a puppet manifest file which sets up my new laptop to my liking. I will improve it as I go along. Here is version 1.0.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="ruby" style="font-family:monospace;"><span style="color:#008000; font-style:italic;"># include apt</span>
&nbsp;
<span style="color:#9966CC; font-weight:bold;">class</span> base::basics <span style="color:#006600; font-weight:bold;">&#123;</span>
        <span style="color:#ff6633; font-weight:bold;">$packages</span> = <span style="color:#006600; font-weight:bold;">&#91;</span><span style="color:#996600;">'git'</span>, <span style="color:#996600;">'subversion'</span>, <span style="color:#996600;">'mc'</span>, <span style="color:#996600;">'vim'</span>, <span style="color:#996600;">'maven'</span>, <span style="color:#996600;">'gradle'</span><span style="color:#006600; font-weight:bold;">&#93;</span>
&nbsp;
        <span style="color:#CC0066; font-weight:bold;">exec</span> <span style="color:#006600; font-weight:bold;">&#123;</span> <span style="color:#996600;">"update"</span>:
                command <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#996600;">"/usr/bin/apt-get update"</span>,
        <span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
        package <span style="color:#006600; font-weight:bold;">&#123;</span> <span style="color:#ff6633; font-weight:bold;">$packages</span>:
                <span style="color:#9966CC; font-weight:bold;">ensure</span> <span style="color:#006600; font-weight:bold;">=&gt;</span> installed,
                <span style="color:#CC0066; font-weight:bold;">require</span> <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#CC0066; font-weight:bold;">Exec</span><span style="color:#006600; font-weight:bold;">&#91;</span><span style="color:#996600;">"update"</span><span style="color:#006600; font-weight:bold;">&#93;</span>,
        <span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
<span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
<span style="color:#9966CC; font-weight:bold;">class</span> base::skype <span style="color:#006600; font-weight:bold;">&#123;</span>
        <span style="color:#CC0066; font-weight:bold;">exec</span> <span style="color:#006600; font-weight:bold;">&#123;</span> <span style="color:#996600;">"add-arc"</span>:
                command <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#996600;">"/usr/bin/dpkg --add-architecture i386"</span>,
        <span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
        <span style="color:#CC0066; font-weight:bold;">exec</span> <span style="color:#006600; font-weight:bold;">&#123;</span> <span style="color:#996600;">"add-repo-skype"</span>:
                command <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#996600;">"/usr/bin/add-apt-repository <span style="color:#000099;">\"</span>deb http://archive.canonical.com/ <span style="color:#000099;">\$</span>(lsb_release -sc) partner<span style="color:#000099;">\"</span>"</span>,
                <span style="color:#CC0066; font-weight:bold;">require</span> <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#CC0066; font-weight:bold;">Exec</span><span style="color:#006600; font-weight:bold;">&#91;</span><span style="color:#996600;">'add-arc'</span><span style="color:#006600; font-weight:bold;">&#93;</span>,
        <span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
        <span style="color:#CC0066; font-weight:bold;">exec</span> <span style="color:#006600; font-weight:bold;">&#123;</span> <span style="color:#996600;">"update-and-install"</span>:
                command <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#996600;">"/usr/bin/apt-get update && /usr/bin/apt-get install skype"</span>,
                <span style="color:#CC0066; font-weight:bold;">require</span> <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#CC0066; font-weight:bold;">Exec</span><span style="color:#006600; font-weight:bold;">&#91;</span><span style="color:#996600;">'add-repo-skype'</span><span style="color:#006600; font-weight:bold;">&#93;</span>,
        <span style="color:#006600; font-weight:bold;">&#125;</span>
<span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
<span style="color:#9966CC; font-weight:bold;">class</span> base::java8 <span style="color:#006600; font-weight:bold;">&#123;</span>
        <span style="color:#008000; font-style:italic;"># Automatically does an update afterwards</span>
        <span style="color:#008000; font-style:italic;"># apt::ppa { 'ppa:webupd8team/java': }</span>
        <span style="color:#CC0066; font-weight:bold;">exec</span> <span style="color:#006600; font-weight:bold;">&#123;</span> <span style="color:#996600;">"add-repo-java"</span>:
                command <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#996600;">"/usr/bin/add-apt-repository -y <span style="color:#000099;">\"</span>ppa:webupd8team/java<span style="color:#000099;">\"</span> && /usr/bin/apt-get update"</span>
        <span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
        <span style="color:#CC0066; font-weight:bold;">exec</span> <span style="color:#006600; font-weight:bold;">&#123;</span> <span style="color:#996600;">"set-accept"</span>:
                command <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#996600;">"/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && /bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true | sudo /usr/bin/debconf-set-selections"</span>,
                <span style="color:#CC0066; font-weight:bold;">require</span> <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#CC0066; font-weight:bold;">Exec</span><span style="color:#006600; font-weight:bold;">&#91;</span><span style="color:#996600;">'add-repo-java'</span><span style="color:#006600; font-weight:bold;">&#93;</span>,
        <span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
        <span style="color:#CC0066; font-weight:bold;">exec</span> <span style="color:#006600; font-weight:bold;">&#123;</span> <span style="color:#996600;">"install"</span>:
                command <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#996600;">"/usr/bin/apt-get install -y oracle-java8-installer"</span>,
                <span style="color:#CC0066; font-weight:bold;">require</span> <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#CC0066; font-weight:bold;">Exec</span><span style="color:#006600; font-weight:bold;">&#91;</span><span style="color:#996600;">'set-accept'</span><span style="color:#006600; font-weight:bold;">&#93;</span>,
        <span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
        <span style="color:#CC0066; font-weight:bold;">exec</span> <span style="color:#006600; font-weight:bold;">&#123;</span> <span style="color:#996600;">"setup_home"</span>:
                command <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#996600;">"/bin/echo <span style="color:#000099;">\"</span>export JDK18_HOME=/usr/lib/jvm/java-8-oracle/<span style="color:#000099;">\"</span> &gt;&gt; /etc/environment"</span>,
                <span style="color:#CC0066; font-weight:bold;">require</span> <span style="color:#006600; font-weight:bold;">=&gt;</span> <span style="color:#CC0066; font-weight:bold;">Exec</span><span style="color:#006600; font-weight:bold;">&#91;</span><span style="color:#996600;">'install'</span><span style="color:#006600; font-weight:bold;">&#93;</span>,
        <span style="color:#006600; font-weight:bold;">&#125;</span>
<span style="color:#006600; font-weight:bold;">&#125;</span>
&nbsp;
<span style="color:#9966CC; font-weight:bold;">include</span> base::basics
<span style="color:#9966CC; font-weight:bold;">include</span> base::skype
<span style="color:#9966CC; font-weight:bold;">include</span> base::java8</pre>
      </td>
    </tr>
  </table>
</div>

I&#8217;ll improve upon it as I go, and you can check it out later from my git repo. I removed the parts which required extra libraries for now, as I want it to run without the need of getting extra stuff installed. I might automate that part as well later on.

EDIT: <a href="https://github.com/Skarlso/puppet/blob/master/manifests/base_setup.pp" target="_blank">https://github.com/Skarlso/puppet/blob/master/manifests/base_setup.pp</a>

Have fun.
  
Gergely.