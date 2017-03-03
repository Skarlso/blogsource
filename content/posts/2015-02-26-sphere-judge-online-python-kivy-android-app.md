---
title: Sphere Judge Online – Python Kivy Android app
author: hannibal
layout: post
date: 2015-02-26
url: /2015/02/26/sphere-judge-online-python-kivy-android-app/
categories:
  - android
  - programming
  - Python
---
Hello folks.

Today I would like to take you on a journey I fought myself through in order to write a python android app, which gets you a random problem from <a href="http://www.spoj.com/problems/classical/" target="_blank">Sphere Judge Online</a>. Then you can mark it as solved and it will be stored as such, and you can move on to the next problem. With the words of Neil deGrasse Tyson, Come with Me!

<!--more-->

<h1 style="text-align: center;">
  Beginnings
</h1>

When I first embarked on this endeavour I ran into numerous errors, many amongst them being compilation issues when I was trying to install libraries.

I started to write down all of these, and then started fresh on a new machine. I realised that ALL of my problems where only because of **ONE **thing. One thing, which I wanted to do, but it ended up being the death of me. And that is&#8230;. \*Drummrolls\* **Python 3. **I tried doing all the things that I started to do, with Python 3. Turns out, that neither libraries are supporting it very well yet. And that&#8217;s including Cython as well, which I thought would be up to speed by now. But sadly, it&#8217;s not.

<h1 style="text-align: center;">
  Prerequisite
</h1>

In order to go any further we need a few things first. For this to work, you&#8217;ll have to perform these things in order as I found out later. And certain versions of certain libraries are required instead of the latest ones.

Depending on the environment you are using, you need to install python-dev and some other graphic libraries. I followed this and that was fine. Latest packages are working alright.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> build-essential <span style="color: #c20cb9; font-weight: bold;">patch</span> git-core ccache ant python-pip python-dev
<span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> ia32-libs  libc6-dev-i386
<span style="color: #c20cb9; font-weight: bold;">sudo</span> <span style="color: #c20cb9; font-weight: bold;">apt-get install</span> lib32stdc++<span style="color: #000000;">6</span> lib32z1</pre>
      </td>
    </tr>
  </table>
</div>

Only install these if you are absolutely certain you need them.

Clone python-android from git into a nice and cosy directory.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #c20cb9; font-weight: bold;">git clone</span> https:<span style="color: #000000; font-weight: bold;">//</span>github.com<span style="color: #000000; font-weight: bold;">/</span>kivy<span style="color: #000000; font-weight: bold;">/</span>python-for-android.git</pre>
      </td>
    </tr>
  </table>
</div>

While this is underway, for python-android you also need <a href="http://developer.android.com/sdk/index.html#Other" target="_blank">android-sdk</a> and <a href="https://developer.android.com/tools/sdk/ndk/index.html" target="_blank">android-ndk</a>. Select the ones which are for your environment. The NDK is needed in order to build the APK out of our python code later on.

After you are done, run ./android and install tools, APIs and other things you want. Make sure you have these set up:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #7a0874; font-weight: bold;">export</span> <span style="color: #007800;">ANDROIDSDK</span>=<span style="color: #000000; font-weight: bold;">/</span>path<span style="color: #000000; font-weight: bold;">/</span>to<span style="color: #000000; font-weight: bold;">/</span>android-sdk
<span style="color: #7a0874; font-weight: bold;">export</span> <span style="color: #007800;">ANDROIDNDK</span>=<span style="color: #000000; font-weight: bold;">/</span>path<span style="color: #000000; font-weight: bold;">/</span>to<span style="color: #000000; font-weight: bold;">/</span>android-ndk
<span style="color: #7a0874; font-weight: bold;">export</span> <span style="color: #007800;">ANDROIDNDKVER</span>=rX
<span style="color: #7a0874; font-weight: bold;">export</span> <span style="color: #007800;">ANDROIDAPI</span>=X</pre>
      </td>
    </tr>
  </table>
</div>

<pre>export PATH=$ANDROIDNDK:$ANDROIDSDK/platform-tools:$ANDROIDSDK/tools:$PATH</pre>

The API version needs to be the one which you installed on your machine.

Now, we have to get a specific version of Cython. In order to do that, execute the following command:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #c20cb9; font-weight: bold;">sudo</span> pip <span style="color: #c20cb9; font-weight: bold;">install</span> <span style="color: #660033;">-I</span> https:<span style="color: #000000; font-weight: bold;">//</span>pypi.python.org<span style="color: #000000; font-weight: bold;">/</span>packages<span style="color: #000000; font-weight: bold;">/</span>source<span style="color: #000000; font-weight: bold;">/</span>C<span style="color: #000000; font-weight: bold;">/</span>Cython<span style="color: #000000; font-weight: bold;">/</span>Cython-0.20.1.tar.gz</pre>
      </td>
    </tr>
  </table>
</div>

Source your new .bash_profile file if you haven&#8217;t done so already.

At this point we are ready to install Kivy. Please follow the instructions for your environment on the respective page from Kivy&#8217;s documentation:

<a href="http://kivy.org/docs/installation/installation.html" target="_blank">http://kivy.org/docs/installation/installation.html</a>

**Note**: For Mac users. In addition, before doing the kivy stuff, and if you would like to execute kivy applications on your mac, you need to install pygame.

It&#8217;s a bit of a hassle but you only need to perform these commands:

Install Quartz => <a href="http://xquartz.macosforge.org/landing/" target="_blank">http://xquartz.macosforge.org/landing/</a>
  
Install Homebrew => <span style="color: #ff9900;">ruby -e &#8220;$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)&#8221;</span>
  
Install some other packages => <span style="color: #ff9900;">brew install hg sdl sdl_image sdl_mixer sdl_ttf portmidi</span>
  
Install pygame => <span style="color: #ff9900;">pip install hg+http://bitbucket.org/pygame/pygame</span>

Once this finishes, you should be good to go for the final command in the prerequisites. Go to your cloned python-android folder and run this (make sure you have ANT installed):

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">.<span style="color: #000000; font-weight: bold;">/</span>distribute.sh <span style="color: #660033;">-m</span> <span style="color: #ff0000;">"openssl pil kivy"</span></pre>
      </td>
    </tr>
  </table>
</div>

Now we are ready for some coding.

<h1 style="text-align: center;">
  Implementation
</h1>

So, finally after our environment is all setup, we can move on to write some python code. Let&#8217;s start with a simple hello world application:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #ff7700;font-weight:bold;">import</span> kivy
kivy.<span style="color: black;">require</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'1.8.0'</span><span style="color: black;">&#41;</span> <span style="color: #808080; font-style: italic;"># 1.8.0 is the latest kivy version</span>
<span style="color: #ff7700;font-weight:bold;">from</span> kivy.<span style="color: black;">lang</span> <span style="color: #ff7700;font-weight:bold;">import</span> Builder
<span style="color: #ff7700;font-weight:bold;">from</span> kivy.<span style="color: black;">uix</span>.<span style="color: black;">gridlayout</span> <span style="color: #ff7700;font-weight:bold;">import</span> GridLayout
<span style="color: #ff7700;font-weight:bold;">from</span> kivy.<span style="color: black;">properties</span> <span style="color: #ff7700;font-weight:bold;">import</span> NumericProperty
<span style="color: #ff7700;font-weight:bold;">from</span> kivy.<span style="color: black;">app</span> <span style="color: #ff7700;font-weight:bold;">import</span> App
&nbsp;
Builder.<span style="color: black;">load_string</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'''
:
    cols: 1
    Label:
        text: 'Welcome to the Hello world'
    Button:
        text: 'Click me! %d' % root.counter
        on_release: root.my_callback()
'''</span><span style="color: black;">&#41;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">class</span> HelloWorldScreen<span style="color: black;">&#40;</span>GridLayout<span style="color: black;">&#41;</span>:
    counter <span style="color: #66cc66;">=</span> NumericProperty<span style="color: black;">&#40;</span><span style="color: #ff4500;"></span><span style="color: black;">&#41;</span>
    <span style="color: #ff7700;font-weight:bold;">def</span> my_callback<span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        <span style="color: #ff7700;font-weight:bold;">print</span> <span style="color: #483d8b;">'The button has been pushed'</span>
        <span style="color: #008000;">self</span>.<span style="color: black;">counter</span> +<span style="color: #66cc66;">=</span> <span style="color: #ff4500;">1</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">class</span> HelloWorldApp<span style="color: black;">&#40;</span>App<span style="color: black;">&#41;</span>:
    <span style="color: #ff7700;font-weight:bold;">def</span> build<span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        <span style="color: #ff7700;font-weight:bold;">return</span> HelloWorldScreen<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">if</span> __name__ <span style="color: #66cc66;">==</span> <span style="color: #483d8b;">'__main__'</span>:
    HelloWorldApp<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>.<span style="color: black;">run</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span></pre>
      </td>
    </tr>
  </table>
</div>

This is a simple Hello World python-android app. Save this into a file called <span style="color: #ff9900;">main.py</span>. Main.py is used to execute the app on your phone. It&#8217;s your entry point. Whatever app you are writing, this has to be where it will begin.

In order to get this installed on our device, we will use python-android&#8217;s distribution.sh. The command to run after you changed directory into python-android is this (make sure that you have a compatible android device plugged in and in developer mode):

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">.<span style="color: #000000; font-weight: bold;">/</span>build.py <span style="color: #660033;">--package</span> org.hello.world <span style="color: #660033;">--name</span> <span style="color: #ff0000;">"Hello world"</span> <span style="color: #660033;">--version</span> <span style="color: #000000;">1.0</span> <span style="color: #660033;">--dir</span> <span style="color: #000000; font-weight: bold;">/</span>PATH<span style="color: #000000; font-weight: bold;">/</span>TO<span style="color: #000000; font-weight: bold;">/</span>helloworld debug installd</pre>
      </td>
    </tr>
  </table>
</div>

Upon success, you should see it on your device. This is how the hello world app looks like:

<h1 style="text-align: center;">
  Finishing up
</h1>

This has been quite the ride so far. We will continue our journey when I&#8217;ll start writing my own app for SPOJ.

Thanks for reading!
Gergely.
