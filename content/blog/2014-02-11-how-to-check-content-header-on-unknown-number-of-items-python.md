+++
author = "hannibal"
categories = ["knowledge", "problem solving", "programming", "Python"]
date = "2014-02-11"
type = "post"
title = "How to check content header on unknown number of items – Python"
url = "/2014/02/11/how-to-check-content-header-on-unknown-number-of-items-python/"

+++

Hello guys. 

I&#8217;d like to share a little something with you. It&#8217;s what I cooked up in Python to check an unknown number of content items in a web application. 

Basically the script runs from a script folder under Grails. It goes through all the configured folders where there is static content like images, javascript, css and so on and so forth. 

And then with curl it calls these items up in using their respective paths&#8217;. This works best on localhost if you have your local environment configured to access these elements because in some places direct access is restricted. 

This script only check static content. Dynamically generated content would have to be hard coded to check.

It only generated a file currently with ERROR on a not match an success on match and not found if it encounters an item which it doesn&#8217;t know about. 

So without further ado&#8230; The Script:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #808080; font-style: italic;">#!/usr/bin/python</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">import</span> pycurl<span style="color: #66cc66;">,</span> <span style="color: #dc143c;">sys</span><span style="color: #66cc66;">,</span> <span style="color: #dc143c;">os</span><span style="color: #66cc66;">,</span> <span style="color: #dc143c;">urllib</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">class</span> Storage:
    <span style="color: #ff7700;font-weight:bold;">def</span> <span style="color: #0000cd;">__init__</span><span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        <span style="color: #008000;">self</span>.<span style="color: black;">contents</span> <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">''</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">def</span> store<span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: #66cc66;">,</span> buf<span style="color: black;">&#41;</span>:
	<span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: #483d8b;">'Content-Type'</span> <span style="color: #ff7700;font-weight:bold;">in</span> buf:
            <span style="color: #008000;">self</span>.<span style="color: black;">contents</span> <span style="color: #66cc66;">=</span> buf
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">def</span> <span style="color: #0000cd;">__str__</span><span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        <span style="color: #ff7700;font-weight:bold;">return</span> <span style="color: #008000;">self</span>.<span style="color: black;">contents</span>
&nbsp;
<span style="color: #808080; font-style: italic;">#print retrieved_headers</span>
&nbsp;
filesInDir <span style="color: #66cc66;">=</span> <span style="color: black;">&#91;</span><span style="color: black;">&#93;</span>
headers <span style="color: #66cc66;">=</span> <span style="color: black;">&#91;</span><span style="color: black;">&#93;</span>
headerRestrictions <span style="color: #66cc66;">=</span> <span style="color: black;">&#123;</span><span style="color: #483d8b;">'.css'</span>: <span style="color: #483d8b;">'Content-Type: text/css'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.jpg'</span>: <span style="color: #483d8b;">'Content-Type: image/jpeg'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.ico'</span>: <span style="color: #483d8b;">'image/vnd.microsoft.icon'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.html'</span>: <span style="color: #483d8b;">'Content-Type: text/html'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.js'</span>: <span style="color: #483d8b;">'Content-Type: application/javascript'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.gif'</span>: <span style="color: #483d8b;">'Content-Type: image/gif'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.png'</span>: <span style="color: #483d8b;">'Content-Type: image/png'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.swf'</span>: <span style="color: #483d8b;">'Content-Type: application/x-shockwave-flash'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.json'</span>: <span style="color: #483d8b;">'Content-Type: application/json'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.htc'</span>: <span style="color: #483d8b;">'Content-Type: text/x-component'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'.xml'</span>: <span style="color: #483d8b;">'Content-Type: application/xml'</span><span style="color: black;">&#125;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">for</span> dirname<span style="color: #66cc66;">,</span> dirnames<span style="color: #66cc66;">,</span> filenames <span style="color: #ff7700;font-weight:bold;">in</span> <span style="color: #dc143c;">os</span>.<span style="color: black;">walk</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'../web-app'</span><span style="color: black;">&#41;</span>:
    <span style="color: #808080; font-style: italic;"># editing the 'dirnames' list will stop os.walk() from recursing into there.</span>
    <span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: #483d8b;">'.git'</span> <span style="color: #ff7700;font-weight:bold;">in</span> dirnames:
        <span style="color: #808080; font-style: italic;"># don't go into any .git directories.</span>
        dirnames.<span style="color: black;">remove</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'.git'</span><span style="color: black;">&#41;</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: #483d8b;">'WEB-INF'</span> <span style="color: #ff7700;font-weight:bold;">in</span> dirnames:
        <span style="color: #808080; font-style: italic;"># don't go into any WEB-INF directories.</span>
        dirnames.<span style="color: black;">remove</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'WEB-INF'</span><span style="color: black;">&#41;</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: #483d8b;">'test'</span> <span style="color: #ff7700;font-weight:bold;">in</span> dirnames:
        <span style="color: #808080; font-style: italic;"># don't go into any test directories.</span>
        dirnames.<span style="color: black;">remove</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'test'</span><span style="color: black;">&#41;</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: #483d8b;">'META-INF'</span> <span style="color: #ff7700;font-weight:bold;">in</span> dirnames:
        <span style="color: #808080; font-style: italic;"># don't go into any META-INF directories.</span>
        dirnames.<span style="color: black;">remove</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'META-INF'</span><span style="color: black;">&#41;</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">for</span> filename <span style="color: #ff7700;font-weight:bold;">in</span> filenames:
	trimmedDir <span style="color: #66cc66;">=</span> dirname.<span style="color: black;">replace</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"web-app/"</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">""</span><span style="color: black;">&#41;</span>
	trimmedDir <span style="color: #66cc66;">=</span> trimmedDir.<span style="color: black;">replace</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"../"</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">""</span><span style="color: black;">&#41;</span>
	filesInDir.<span style="color: black;">append</span><span style="color: black;">&#40;</span><span style="color: #dc143c;">os</span>.<span style="color: black;">path</span>.<span style="color: black;">join</span><span style="color: black;">&#40;</span>trimmedDir<span style="color: #66cc66;">,</span> filename<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
    <span style="color: #808080; font-style: italic;">#    print os.path.join(dirname, filename)</span>
&nbsp;
f <span style="color: #66cc66;">=</span> <span style="color: #008000;">open</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"headersandfiles.txt"</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">"w"</span><span style="color: black;">&#41;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">for</span> fileName <span style="color: #ff7700;font-weight:bold;">in</span> filesInDir:
    retrieved_body <span style="color: #66cc66;">=</span> Storage<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
    retrieved_headers <span style="color: #66cc66;">=</span> Storage<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
    c <span style="color: #66cc66;">=</span> pycurl.<span style="color: black;">Curl</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
    fileName <span style="color: #66cc66;">=</span> fileName.<span style="color: black;">replace</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">" "</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">"%20"</span><span style="color: black;">&#41;</span>
    url <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">'http://localhost:8080/%s'</span> % fileName
    c.<span style="color: black;">setopt</span><span style="color: black;">&#40;</span>c.<span style="color: black;">URL</span><span style="color: #66cc66;">,</span> url<span style="color: black;">&#41;</span>
    c.<span style="color: black;">setopt</span><span style="color: black;">&#40;</span>c.<span style="color: black;">WRITEFUNCTION</span><span style="color: #66cc66;">,</span> retrieved_body.<span style="color: black;">store</span><span style="color: black;">&#41;</span>
    c.<span style="color: black;">setopt</span><span style="color: black;">&#40;</span>c.<span style="color: black;">HEADERFUNCTION</span><span style="color: #66cc66;">,</span> retrieved_headers.<span style="color: black;">store</span><span style="color: black;">&#41;</span>
    c.<span style="color: black;">perform</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
    c.<span style="color: black;">close</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
    fileLine <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">""</span>
    fileNameBase<span style="color: #66cc66;">,</span> fileExtension <span style="color: #66cc66;">=</span> <span style="color: #dc143c;">os</span>.<span style="color: black;">path</span>.<span style="color: black;">splitext</span><span style="color: black;">&#40;</span>fileName<span style="color: black;">&#41;</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">if</span> headerRestrictions.<span style="color: black;">has_key</span><span style="color: black;">&#40;</span>fileExtension<span style="color: black;">&#41;</span>:
<span style="color: #808080; font-style: italic;">#	print "Header:%s, Content:%s" % (headerRestrictions[fileExtension], retrieved_headers.__str__())</span>
        fileLine <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"CORRECT: Content: %s; Header: %s"</span> % <span style="color: black;">&#40;</span>fileName<span style="color: #66cc66;">,</span> retrieved_headers<span style="color: black;">&#41;</span> <span style="color: #ff7700;font-weight:bold;">if</span> headerRestrictions<span style="color: black;">&#91;</span>fileExtension<span style="color: black;">&#93;</span> <span style="color: #66cc66;">==</span> retrieved_headers.<span style="color: #0000cd;">__str__</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>.<span style="color: black;">strip</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span> <span style="color: #ff7700;font-weight:bold;">else</span> <span style="color: #483d8b;">"ERROR: Content: %s; Header: %s; URL: %s"</span> % <span style="color: black;">&#40;</span>fileName<span style="color: #66cc66;">,</span> retrieved_headers<span style="color: #66cc66;">,</span> <span style="color: #483d8b;">"http://localhost:8080/%s<span style="color: #000099; font-weight: bold;">\n</span>"</span> % fileName<span style="color: black;">&#41;</span>
    <span style="color: #ff7700;font-weight:bold;">else</span>:
	fileLine <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"NOT FOUND: Content: %s; Header: %s"</span> % <span style="color: black;">&#40;</span>fileName<span style="color: #66cc66;">,</span> retrieved_headers<span style="color: black;">&#41;</span>
&nbsp;
    f.<span style="color: black;">write</span><span style="color: black;">&#40;</span>fileLine<span style="color: black;">&#41;</span>
    headers.<span style="color: black;">append</span><span style="color: black;">&#40;</span>retrieved_headers.<span style="color: #0000cd;">__str__</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
&nbsp;
f.<span style="color: black;">close</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span></pre>
      </td>
    </tr>
  </table>
</div>

Hope you like it. Feel free to improve however you want. 

Thanks for reading,
  
Gergely.