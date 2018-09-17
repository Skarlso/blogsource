+++
author = "hannibal"
categories = ["android", "JavaScript", "knowledge", "programming"]
date = "2015-01-29"
type = "post"
title = "JavaScript Web Framework – Meteor"
url = "/2015/01/29/javascript-web-framework-meteor/"

+++

Hi,

This time I would like to write about something that interests me. I wanted to try out a pure JavaScript web framework.

My choice is: <a href="https://www.meteor.com/" target="_blank">Meteor</a>. Looks interesting enough and it was recommended by a friend of mine. So, let&#8217;s dive in.

<!--more-->

#### **Installation**

As always, one starts with installation. The page tells us to follow this simple step:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">curl https:<span style="color: #000000; font-weight: bold;">//</span>install.meteor.com<span style="color: #000000; font-weight: bold;">/</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">sh</span></pre>
      </td>
    </tr>
  </table>
</div>

Easy enough, when you are on Linux. Turns out, that there is no official release yet for Windows. I&#8217;m in luck then. After running the command though, I saw this popping up into my face:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">curl: <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">60</span><span style="color: #7a0874; font-weight: bold;">&#41;</span> Peer certificate cannot be authenticated with known CA certificates
More details here: http:<span style="color: #000000; font-weight: bold;">//</span>curl.haxx.se<span style="color: #000000; font-weight: bold;">/</span>docs<span style="color: #000000; font-weight: bold;">/</span>sslcerts.html</pre>
      </td>
    </tr>
  </table>
</div>

There is always something&#8230; in that case a more accurate command to use would be the following:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">curl <span style="color: #660033;">-k</span> https:<span style="color: #000000; font-weight: bold;">//</span>install.meteor.com<span style="color: #000000; font-weight: bold;">/</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">sh</span></pre>
      </td>
    </tr>
  </table>
</div>

This will force an insecure download. You might not face this issue, but just in case you do, use this command instead.

Branching off here. For those of you whom the curl didn&#8217;t work because you are sitting behind a proxy you can specify a &#8211;proxy  protocol//username:password@proxy:port after your curl. Of course if that doesn&#8217;t work then the script won&#8217;t work either.

So open the script in one of your favourite editors, for me it&#8217;s Sublime text, and find this line: &#8220;_Downloading Meteor distribution_&#8220;. Lo, and behold; it uses curl. This is the only one in the script, so just edit it by adding in your &#8211;proxy setting as before and you should be right on track.

If that still gives you problems, try this:

Assuming that your browser is set up correctly with the proxy and just command line commands aren&#8217;t working, you can go to this URL defined by the variable TARBALL_URL:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #007800;">TARBALL_URL</span>=<span style="color: #ff0000;">"https://d3sqy0vbqsdhku.cloudfront.net/packages-bootstrap/<span style="color: #007800;">${RELEASE}</span>/meteor-bootstrap-<span style="color: #007800;">${PLATFORM}</span>.tar.gz"</span></pre>
      </td>
    </tr>
  </table>
</div>

Note that there are two variables in there. For me these are:

RELEASE: 1.0.3.1
  
PLATFORM: os.linux.x86_64

The full URL is:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">https:<span style="color: #000000; font-weight: bold;">//</span>d3sqy0vbqsdhku.cloudfront.net<span style="color: #000000; font-weight: bold;">/</span>packages-bootstrap<span style="color: #000000; font-weight: bold;">/</span>1.0.3.1<span style="color: #000000; font-weight: bold;">/</span>meteor-bootstrap-os.linux.x86_64.tar.gz</pre>
      </td>
    </tr>
  </table>
</div>

Download the latest tarball and delete the CURL AND TAR command on the following line. After that, you just have to extract the tarball and move the directory to ~/.meteor.

Now you can run your sh again and you should be on the road, for sure this time.

Just to make sure, these are the line which you need to comment out:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #666666; font-style: italic;"># If you already have a tropohouse/warehouse, we do a clean install here:</span>
<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #7a0874; font-weight: bold;">&#91;</span> <span style="color: #660033;">-e</span> <span style="color: #ff0000;">"<span style="color: #007800;">$HOME</span>/.meteor"</span> <span style="color: #7a0874; font-weight: bold;">&#93;</span>; <span style="color: #000000; font-weight: bold;">then</span>
<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"Removing your existing Meteor installation."</span>
<span style="color: #c20cb9; font-weight: bold;">rm</span> <span style="color: #660033;">-rf</span> <span style="color: #ff0000;">"<span style="color: #007800;">$HOME</span>/.meteor"</span>
<span style="color: #000000; font-weight: bold;">fi</span>
&nbsp;
<span style="color: #007800;">TARBALL_URL</span>=<span style="color: #ff0000;">"https://d3sqy0vbqsdhku.cloudfront.net/packages-bootstrap/<span style="color: #007800;">${RELEASE}</span>/meteor-bootstrap-<span style="color: #007800;">${PLATFORM}</span>.tar.gz"</span>
&nbsp;
<span style="color: #007800;">INSTALL_TMPDIR</span>=<span style="color: #ff0000;">"<span style="color: #007800;">$HOME</span>/.meteor-install-tmp"</span>
<span style="color: #c20cb9; font-weight: bold;">rm</span> <span style="color: #660033;">-rf</span> <span style="color: #ff0000;">"<span style="color: #007800;">$INSTALL_TMPDIR</span>"</span>
<span style="color: #c20cb9; font-weight: bold;">mkdir</span> <span style="color: #ff0000;">"<span style="color: #007800;">$INSTALL_TMPDIR</span>"</span>
<span style="color: #7a0874; font-weight: bold;">echo</span> <span style="color: #ff0000;">"Downloading Meteor distribution"</span>
curl <span style="color: #660033;">--proxy</span> https:<span style="color: #000000; font-weight: bold;">//</span>ggbrau:Daleks37<span style="color: #000000; font-weight: bold;">@</span>10.120.28.130:<span style="color: #000000;">80</span>--progress-bar <span style="color: #660033;">--fail</span> <span style="color: #ff0000;">"<span style="color: #007800;">$TARBALL_URL</span>"</span> <span style="color: #000000; font-weight: bold;">|</span> <span style="color: #c20cb9; font-weight: bold;">tar</span> <span style="color: #660033;">-xzf</span> - <span style="color: #660033;">-C</span> <span style="color: #ff0000;">"<span style="color: #007800;">$INSTALL_TMPDIR</span>"</span> <span style="color: #660033;">-o</span>
<span style="color: #666666; font-style: italic;"># bomb out if it didn't work, eg no net</span>
<span style="color: #7a0874; font-weight: bold;">test</span> <span style="color: #660033;">-x</span> <span style="color: #ff0000;">"<span style="color: #007800;">${INSTALL_TMPDIR}</span>/.meteor/meteor"</span>
<span style="color: #c20cb9; font-weight: bold;">mv</span> <span style="color: #ff0000;">"<span style="color: #007800;">${INSTALL_TMPDIR}</span>/.meteor"</span> <span style="color: #ff0000;">"<span style="color: #007800;">$HOME</span>"</span>
<span style="color: #c20cb9; font-weight: bold;">rm</span> <span style="color: #660033;">-rf</span> <span style="color: #ff0000;">"<span style="color: #007800;">${INSTALL_TMPDIR}</span>"</span>
<span style="color: #666666; font-style: italic;"># just double-checking :)</span>
<span style="color: #7a0874; font-weight: bold;">test</span> <span style="color: #660033;">-x</span> <span style="color: #ff0000;">"<span style="color: #007800;">$HOME</span>/.meteor/meteor"</span></pre>
      </td>
    </tr>
  </table>
</div>

#### 

#### Getting started

After a nice installation process we can continue to the getting started phase.

So, the documentation tells us that we have to simply execute a command.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">meteor create simple-todos</pre>
      </td>
    </tr>
  </table>
</div>

At this point we should get a directory structure which is written in the manual. And, behold, that&#8217;s exactly what happened. As usually, creating a skeleton is easy. Lets run the app. For that, the command is:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">meteor</pre>
      </td>
    </tr>
  </table>
</div>

I can do that, I think.

And sure enough, I&#8217;ve got this little message, which I actually expected to see:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">Can<span style="color: #ff0000;">'t listen on port 3000. Perhaps another Meteor is running?</span></pre>
      </td>
    </tr>
  </table>
</div>

In this world, where there are tons of applications running on your dev environment at any given time, it&#8217;s possible to have something already running on the port 3000. Luckily this is something that&#8217;s anticipated by now, and we are presented with an option to add in a proxy setting of our choice with &#8211;port <port>.

After I did that, I&#8217;ve got a nice confirm message that meteor is up and running. A quick check on the presented URL provided me with the confidence that my app is indeed reachable.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">App running at: http:<span style="color: #000000; font-weight: bold;">//</span>localhost:<span style="color: #000000;">9999</span><span style="color: #000000; font-weight: bold;">/</span></pre>
      </td>
    </tr>
  </table>
</div>

#### After Getting Started&#8230;

Now that we know that it&#8217;s up and running we can continue with the tutorial. Up comes next a simple Todo list application with Templates. It&#8217;s telling us to replace the code in the default starter app. At this point I&#8217;m wondering if it can hotswap. It should, since javascript and HTML is dynamic so there should be no problems there, right?

And sure enough, the moment I replaced the code and checked on my server status, I could see this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">Client modified <span style="color: #660033;">--</span> refreshing
Meteor server restarted</pre>
      </td>
    </tr>
  </table>
</div>

With a brief flash of &#8220;Rebuilding&#8230;&#8221;. So it does sort of work. It did, however, restart the server it just did it without your manual intervention. Which is nice, but on a larger scale application it might prove to be a tad bit annoying. For example, I add another item to the list, and suddenly, the server is restarted.

Since, I am a tester, let&#8217;s see how it handles some problems.

I modified the JavaScript so that it has a syntax error.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="javascript" style="font-family:monospace;"><span style="color: #006600; font-style: italic;">// simple-todos.js</span>
<span style="color: #000066; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>Meteor.<span style="color: #660066;">isClient</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
  <span style="color: #006600; font-style: italic;">// This code only runs on the client</span>
  Template.<span style="color: #660066;">body</span>.<span style="color: #660066;">helpers</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#123;</span>
    tasks<span style="color: #339933;">:</span> <span style="color: #009900;">&#91;</span>
      <span style="color: #009900;">&#123;</span> text<span style="color: #339933;">:</span> <span style="color: #3366CC;">"This is task 1"</span> <span style="color: #009900;">&#125;</span><span style="color: #339933;">,</span>
      <span style="color: #009900;">&#123;</span> text<span style="color: #339933;">:</span> <span style="color: #3366CC;">"This is task 2"</span> <span style="color: #009900;">&#125;</span><span style="color: #339933;">,</span>
      <span style="color: #009900;">&#123;</span> text<span style="color: #339933;">:</span> <span style="color: #3366CC;">"This is task 3"</span> <span style="color: #009900;">&#125;</span>
      <span style="color: #009900;">&#123;</span> text<span style="color: #339933;">:</span> <span style="color: #3366CC;">"This is task 4"</span> <span style="color: #009900;">&#125;</span>
    <span style="color: #009900;">&#93;</span>
  <span style="color: #009900;">&#125;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Note the missing &#8220;,&#8221;. And, nicely enough I&#8217;m getting an error message telling me that I messed something up:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">Errors prevented startup:
&nbsp;
While building the application:
my_cool_app.js:<span style="color: #000000;">10</span>:<span style="color: #000000;">7</span>: Unexpected token <span style="color: #7a0874; font-weight: bold;">&#123;</span>
&nbsp;
Your application has errors. Waiting <span style="color: #000000; font-weight: bold;">for</span> <span style="color: #c20cb9; font-weight: bold;">file</span> change.</pre>
      </td>
    </tr>
  </table>
</div>

It even tells you where the error is and it&#8217;s waiting for you to fix it. After I&#8217;ve corrected my error it compiled fine and the application is up and running. Deleting the files did little difference as did corrupting the HTML pages or the CSS file. Nothing to see here, moving on&#8230;

#### Android Device

I&#8217;m sure everybody can read a manual and continue with collections, forms, events and such. What I&#8217;m more interested in is that Meteor promises it can run on Android devices. Now that perked my curiosity. With the rise of mobile devices, the desktop platform is slowly pushed back into a dark corner where even a <a href="http://mistborn.wikia.com/wiki/Tineye" target="_blank">Tineye </a>would have problems seeing it.

Hence, I want to see how easy it really is.

Meteor gives you a set of commands to install the android sdk and droid support for your application, which is nice. You just need to run this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">meteor install-sdk android
meteor add-platform android <span style="color: #666666; font-style: italic;"># Perform this step in the app's folder and agree to terms and conditions.</span></pre>
      </td>
    </tr>
  </table>
</div>

Now, if you are like me, someone who has experience with the android SDK and its emulator, you&#8217;ll know that running that thing requires more time and processing power than simulating the chances of Leonardo DiCaprio winning an Oscar. I&#8217;ll use a real device instead. For that, it appears I only have to run a simple command again.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">meteor run android-device</pre>
      </td>
    </tr>
  </table>
</div>

And sure enough the app appeared on my device.

This is actually quite awesome. I only plugged in my device, enabled developer options and USB debugging and that&#8217;s it. I&#8217;m quite impressed so far with Meteor and the Power of JavaScript. The app is on my phone and the static JavaScript parts are still working even though I shut the server down.

So my next burning question is&#8230; Will it Blend? I mean, Perform?

#### Benchmarking

So, now that I know that using, installing and getting started is pretty simple, what I also would like to know is how well it performs.

I have a quad core i7 16GB RAM Samsung SSD running Linux. Let&#8217;s see 100 threads 10 second interval 10 times loop for a start. Look at how gorgeous this is.

40ms on average. Now let&#8217;s crank it up and I&#8217;m performing the test on a separate machine but still on the same network. 1000 threads.

This time I&#8217;ve got a bit more churn and my pc started to fan like there is no tomorrow. But the server stayed stable. Latency did not waver for a bit. Next, 10.000 for as long as my machine can handle it&#8230;. Better save my work. Hah, my JMeter died. But it clocked at an average of 1000ms response time and the server stayed absolutely stable with no package lost, or errors.

#### Conclusion

I can say with a full heart that I&#8217;m impressed by Meteor and I very much like it. It&#8217;s easy to use, even more easy to install and definitely can handle itself given that it&#8217;s rather lightweight. The hot swapping / server re-starting can&#8217;t be avoided, but that&#8217;s only a minor inconvenience and we got used to that already.

I recommend Meteor and I&#8217;ll be playing around with it a bit more for sure.

Thanks for reading!
Gergely.