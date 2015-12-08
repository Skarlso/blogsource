---
title: Sphere Judge Online – Python Kivy Android app – Part 2
author: hannibal
layout: post
date: 2015-03-02
url: /2015/03/02/sphere-judge-online-python-kivy-android-app-part-2/
categories:
  - android
  - programming
  - Python
---
Here we are again. I will attempt to further this little journey of mine into the land of Android and Python.

This is the second part of the advanture you can read the first one a little bit back.

<!--more-->

<h1 style="text-align: center;">
  The Script
</h1>

&nbsp;

We left off at a point where I successfully configured my environment and compiled my first hello world APK. At that point it took a little bit fiddling to get it to work on my phone.

Now, I have progressed a little bit into spoj&#8217;s page parsing. The code so far is as follows:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;">__author__ <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">'hannibal'</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">import</span> requests
<span style="color: #ff7700;font-weight:bold;">from</span> <span style="color: #dc143c;">random</span> <span style="color: #ff7700;font-weight:bold;">import</span> randint
<span style="color: #ff7700;font-weight:bold;">import</span> lxml.<span style="color: black;">html</span> <span style="color: #ff7700;font-weight:bold;">as</span> lh
&nbsp;
random_page_number <span style="color: #66cc66;">=</span> randint<span style="color: black;">&#40;</span><span style="color: #ff4500;"></span><span style="color: #66cc66;">,</span> <span style="color: #ff4500;">63</span><span style="color: black;">&#41;</span> <span style="color: #808080; font-style: italic;"># 63 being the maximum page number at spoj</span>
r <span style="color: #66cc66;">=</span> requests.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"http://www.spoj.com/problems/classical/sort=0,start=%d"</span> % <span style="color: black;">&#40;</span>random_page_number * <span style="color: #ff4500;">50</span> - <span style="color: #ff4500;">50</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
<span style="color: #808080; font-style: italic;"># Problem Div XPath =&gt; //[@class="problems"]</span>
&nbsp;
spoj_page <span style="color: #66cc66;">=</span> lh.<span style="color: black;">document_fromstring</span><span style="color: black;">&#40;</span>r.<span style="color: black;">text</span><span style="color: black;">&#41;</span>
links_to_problems <span style="color: #66cc66;">=</span> spoj_page<span style="color: black;">&#91;</span><span style="color: #ff4500;"></span><span style="color: black;">&#93;</span>.<span style="color: black;">xpath</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"//tr[@class='problemrow']/td[2]/a"</span><span style="color: black;">&#41;</span>
&nbsp;
current_link <span style="color: #66cc66;">=</span> links_to_problems<span style="color: black;">&#91;</span>randint<span style="color: black;">&#40;</span><span style="color: #ff4500;"></span><span style="color: #66cc66;">,</span> <span style="color: #008000;">len</span><span style="color: black;">&#40;</span>links_to_problems<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span><span style="color: black;">&#93;</span>
<span style="color: #ff7700;font-weight:bold;">print</span><span style="color: black;">&#40;</span>current_link.<span style="color: black;">attrib</span><span style="color: black;">&#91;</span><span style="color: #483d8b;">'href'</span><span style="color: black;">&#93;</span><span style="color: black;">&#41;</span>
r <span style="color: #66cc66;">=</span> requests.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"http://www.spoj.com/%s"</span> % current_link.<span style="color: black;">attrib</span><span style="color: black;">&#91;</span><span style="color: #483d8b;">'href'</span><span style="color: black;">&#93;</span><span style="color: black;">&#41;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">print</span><span style="color: black;">&#40;</span>r.<span style="color: black;">text</span>.<span style="color: black;">encode</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"utf-8"</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span></pre>
      </td>
    </tr>
  </table>
</div>

This is pretty straight forward so far. It gets the problems page, loads in all of the links and prints it out.

My goal is an application which looks something like this:

\___\___\___\___\___\___\___\___\___\___\___\___\___\___\___
  
|   \___\___\___\___\___\___\___\___\___\___\___\___\___\___  |
  
|  |                                                                           | |
  
|  |                                                                           | |
  
|  |                    Display Problem Description               | |
  
|  |                                                                           | |
  
|  |                                                                           | |
  
|  |                                                                           | |
  
|  |\___\___\___\___\___\___\___\___\___\___\___\___\_____ | |
  
|                                                                                 |
  
|                                                                                 |
  
|                         Button:Finish Problem                        |
  
|                                                                                 |
  
|                         Button:Next Problem                          |
  
|\___\___\___\___\___\___\___\___\___\___\___\___\___\_____ |

It&#8217;s very basic. When it loads up, it will gather and display a new problem. You have two options, either get a new one, or save / finish this item, saying you never want to see it again.

Let&#8217;s put the first part into an android app. Just gather data, and get it disaplyed.

\*Queue a days worth of hacking and frustrated cussing.\*

So, turns out it&#8217;s not as easy as I would have liked it to be. I ran into some pretty nasty problems. Some of them I&#8217;ll write down below for the record, and an attempted solution as well.

<h1 style="text-align: center;">
  Problems
</h1>

**#1:** **Problem:** Libraries. I&#8217;m using lxml and requests. Requests is a pure python library, but lxml is partially C. Which apparently is not very well supported yet.
  
**Solution (Partial):** I could optain request by two ways, but the most simple one, was basically just building my distribution with the optional requests module like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">.<span style="color: #000000; font-weight: bold;">/</span>distribute.sh <span style="color: #660033;">-m</span> <span style="color: #ff0000;">"openssl pil requests kivy"</span></pre>
      </td>
    </tr>
  </table>
</div>

Attempting to do the same with LXML resulted in a compile issue which I tracked down to something like: &#8220;sorry, but we don&#8217;t support OSX&#8221;. But it&#8217;s okay. There are other ways to parse an html page, I just really like the xpath filter. So I soldiered on with trying to get something to work at least.

**#3: Problem:** _Bogus compile time exception._ There were some exceptions on the way when I was trying to compile with buildozer. **Solution:** It&#8217;s interesting because previously my solution to another compile time issue was to use a specific version of Cython. But this time the solution was to actually remove that version and install the latest one. Which is 0.22 as of the time of this writing. So:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;"><span style="color: #c20cb9; font-weight: bold;">sudo</span> pip update cython</pre>
      </td>
    </tr>
  </table>
</div>

**#2: Problem:** Connection. So now, I&#8217;m down to the bare bone. At this point, I just want to see a page source in a label. My code looks like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #ff7700;font-weight:bold;">import</span> kivy
kivy.<span style="color: black;">require</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'1.8.0'</span><span style="color: black;">&#41;</span>
<span style="color: #ff7700;font-weight:bold;">from</span> kivy.<span style="color: black;">lang</span> <span style="color: #ff7700;font-weight:bold;">import</span> Builder
<span style="color: #ff7700;font-weight:bold;">from</span> kivy.<span style="color: black;">uix</span>.<span style="color: black;">gridlayout</span> <span style="color: #ff7700;font-weight:bold;">import</span> GridLayout
<span style="color: #ff7700;font-weight:bold;">from</span> kivy.<span style="color: black;">properties</span> <span style="color: #ff7700;font-weight:bold;">import</span> NumericProperty
<span style="color: #ff7700;font-weight:bold;">from</span> kivy.<span style="color: black;">app</span> <span style="color: #ff7700;font-weight:bold;">import</span> App
&nbsp;
<span style="color: #ff7700;font-weight:bold;">import</span> requests
<span style="color: #ff7700;font-weight:bold;">from</span> <span style="color: #dc143c;">random</span> <span style="color: #ff7700;font-weight:bold;">import</span> randint
<span style="color: #808080; font-style: italic;"># import lxml.html as lh</span>
&nbsp;
<span style="color: #808080; font-style: italic;"># import sys</span>
<span style="color: #808080; font-style: italic;"># sys.path.append('/sdcard/com.googlecode.pythonforandroid/extras/python/site-packages')</span>
&nbsp;
&nbsp;
Builder.<span style="color: black;">load_string</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'''
:
    cols: 1
    Label:
        text: root.get_problem()
    Button:
        text: 'Click me! %d' % root.counter
        on_release: root.my_callback()
'''</span><span style="color: black;">&#41;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">class</span> SpojAppScreen<span style="color: black;">&#40;</span>GridLayout<span style="color: black;">&#41;</span>:
    counter <span style="color: #66cc66;">=</span> NumericProperty<span style="color: black;">&#40;</span><span style="color: #ff4500;"></span><span style="color: black;">&#41;</span>
    <span style="color: #ff7700;font-weight:bold;">def</span> my_callback<span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        <span style="color: #ff7700;font-weight:bold;">print</span> <span style="color: #483d8b;">'The button has been pushed'</span>
        <span style="color: #008000;">self</span>.<span style="color: black;">counter</span> +<span style="color: #66cc66;">=</span> <span style="color: #ff4500;">1</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">def</span> get_problem<span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        random_page_number <span style="color: #66cc66;">=</span> randint<span style="color: black;">&#40;</span><span style="color: #ff4500;"></span><span style="color: #66cc66;">,</span> <span style="color: #ff4500;">63</span><span style="color: black;">&#41;</span> <span style="color: #808080; font-style: italic;"># 63 being the maximum page number at spoj</span>
        r <span style="color: #66cc66;">=</span> requests.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"http://www.spoj.com/problems/classical/sort=0,start=%d"</span> % <span style="color: black;">&#40;</span>random_page_number * <span style="color: #ff4500;">50</span> - <span style="color: #ff4500;">50</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
&nbsp;
        <span style="color: #808080; font-style: italic;"># Problem Div XPath =&gt; //[@class="problems"]</span>
&nbsp;
        <span style="color: #808080; font-style: italic;"># spoj_page = lh.document_fromstring(r.text)</span>
        <span style="color: #808080; font-style: italic;"># links_to_problems = spoj_page[0].xpath("//tr[@class='problemrow']/td[2]/a")</span>
&nbsp;
        <span style="color: #808080; font-style: italic;"># current_link = links_to_problems[randint(0, len(links_to_problems))]</span>
        <span style="color: #808080; font-style: italic;"># print(current_link.attrib['href'])</span>
        <span style="color: #808080; font-style: italic;"># r = requests.get("http://www.spoj.com/%s" % current_link.attrib['href'])</span>
        <span style="color: #808080; font-style: italic;"># print(r.text.encode("utf-8"))</span>
        <span style="color: #ff7700;font-weight:bold;">return</span> r.<span style="color: black;">text</span>.<span style="color: black;">encode</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"utf-8"</span><span style="color: black;">&#41;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">class</span> SpojApp<span style="color: black;">&#40;</span>App<span style="color: black;">&#41;</span>:
    <span style="color: #ff7700;font-weight:bold;">def</span> build<span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        <span style="color: #ff7700;font-weight:bold;">return</span> SpojAppScreen<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">if</span> __name__ <span style="color: #66cc66;">==</span> <span style="color: #483d8b;">'__main__'</span>:
    SpojApp<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>.<span style="color: black;">run</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span></pre>
      </td>
    </tr>
  </table>
</div>

However, running this results in a connection error in adb logcat:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:  kivy.lang.BuilderException: Parser: File <span style="color: #ff0000;">""</span>, line <span style="color: #000000;">5</span>:
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:  ...
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:        <span style="color: #000000;">3</span>:    cols: <span style="color: #000000;">1</span>
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:        <span style="color: #000000;">4</span>:    Label:
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:  <span style="color: #000000; font-weight: bold;">&</span>gt;<span style="color: #000000; font-weight: bold;">&</span>gt;    <span style="color: #000000;">5</span>:        text: root.get_problem<span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:        <span style="color: #000000;">6</span>:    Button:
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:        <span style="color: #000000;">7</span>:        text: <span style="color: #ff0000;">'Click me! %d'</span> <span style="color: #000000; font-weight: bold;">%</span> root.counter
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:  ...
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:  BuilderException: Parser: File <span style="color: #ff0000;">""</span>, line <span style="color: #000000;">5</span>:
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:  ...
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:        <span style="color: #000000;">3</span>:    cols: <span style="color: #000000;">1</span>
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:        <span style="color: #000000;">4</span>:    Label:
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:  <span style="color: #000000; font-weight: bold;">&</span>gt;<span style="color: #000000; font-weight: bold;">&</span>gt;    <span style="color: #000000;">5</span>:        text: root.get_problem<span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:        <span style="color: #000000;">6</span>:    Button:
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:        <span style="color: #000000;">7</span>:        text: <span style="color: #ff0000;">'Click me! %d'</span> <span style="color: #000000; font-weight: bold;">%</span> root.counter
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:  ...
I<span style="color: #000000; font-weight: bold;">/</span>python  <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">27610</span><span style="color: #7a0874; font-weight: bold;">&#41;</span>:  ConnectionError: <span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #ff0000;">'Connection aborted.'</span>, gaierror<span style="color: #7a0874; font-weight: bold;">&#40;</span><span style="color: #000000;">4</span>, <span style="color: #ff0000;">'non-recoverable failure in name resolution.'</span><span style="color: #7a0874; font-weight: bold;">&#41;</span><span style="color: #7a0874; font-weight: bold;">&#41;</span></pre>
      </td>
    </tr>
  </table>
</div>

**Solution:** I tried simply putting out a random number at some point, which actullay worked, so I know it&#8217;s the connection. I&#8217;m guessing I need permission to access the network. Which would be this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="xml" style="font-family:monospace;">uses-permission android:name="android.permission.INTERNET"</pre>
      </td>
    </tr>
  </table>
</div>

And yes! Building and installing it with this additional permission got me so far as I can display the web page&#8217;s content in a label.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">.<span style="color: #000000; font-weight: bold;">/</span>build.py <span style="color: #660033;">--package</span> org.spoj <span style="color: #660033;">--permission</span> INTERNET <span style="color: #660033;">--name</span> <span style="color: #ff0000;">"Spoj"</span> <span style="color: #660033;">--version</span> <span style="color: #000000;">1.0</span> <span style="color: #660033;">--dir</span> <span style="color: #000000; font-weight: bold;">/</span>Users<span style="color: #000000; font-weight: bold;">/</span>hannibal<span style="color: #000000; font-weight: bold;">/</span>PythonProjects<span style="color: #000000; font-weight: bold;">/</span>spoj<span style="color: #000000; font-weight: bold;">/</span> debug</pre>
      </td>
    </tr>
  </table>
</div>

There is a saying that you should end on a high note, so that is what I&#8217;m going to do here right now. Join me next time, when I&#8217;ll try to replace lxml with something else&#8230;

Thanks for reading!
  
Gergely.