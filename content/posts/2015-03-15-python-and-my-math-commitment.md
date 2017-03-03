---
title: Python and my Math commitment
author: hannibal
layout: post
date: 2015-03-15
url: /2015/03/15/python-and-my-math-commitment/
categories:
  - programming
  - Python
tags:
  - mathematics
---
Let&#8217;s talk about plans. It&#8217;s good to have one. For example, I have a plan for this year.

I kind of like math. So, I have this book:

It&#8217;s 1400 pages long and basically, has everything in it. It&#8217;s a rather exhaustive book. Hence, my plan is to finish the book by the end of 2015 and write a couple of python scripts that calculate something interesting.

For example, Newton&#8217;s law of cooling how I learned it is:

<img src="http://www.forkosh.com/mathtex.cgi?t=k*log_{2.5}\frac{T_0-K}{T-K}" style="float:top;" border="0px" />

Where k => a material&#8217;s surface based constant. Tzero => initial temperature. T => target temperature. K => Environment&#8217;s temperature.

A simple python script for this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #808080; font-style: italic;"># Calculating Newton's law of Cooling</span>
<span style="color: #ff7700;font-weight:bold;">from</span> <span style="color: #dc143c;">__future__</span> <span style="color: #ff7700;font-weight:bold;">import</span> division
<span style="color: #ff7700;font-weight:bold;">import</span> <span style="color: #dc143c;">sys</span>
<span style="color: #ff7700;font-weight:bold;">from</span> <span style="color: #dc143c;">math</span> <span style="color: #ff7700;font-weight:bold;">import</span> log
&nbsp;
<span style="color: #ff7700;font-weight:bold;">def</span> calculation<span style="color: black;">&#40;</span>k<span style="color: #66cc66;">,</span> Tz<span style="color: #66cc66;">,</span> T<span style="color: #66cc66;">,</span> K<span style="color: black;">&#41;</span>:
	res <span style="color: #66cc66;">=</span> <span style="color: black;">&#40;</span>Tz - K<span style="color: black;">&#41;</span>/<span style="color: black;">&#40;</span>T - K<span style="color: black;">&#41;</span>
	<span style="color: #ff7700;font-weight:bold;">return</span> k * <span style="color: black;">&#40;</span>log<span style="color: black;">&#40;</span>res<span style="color: #66cc66;">,</span> <span style="color: #ff4500;">2.5</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
&nbsp;
k <span style="color: #66cc66;">=</span> <span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#91;</span><span style="color: #ff4500;">1</span><span style="color: black;">&#93;</span>
Tz <span style="color: #66cc66;">=</span> <span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#91;</span><span style="color: #ff4500;">2</span><span style="color: black;">&#93;</span>
T <span style="color: #66cc66;">=</span> <span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#91;</span><span style="color: #ff4500;">3</span><span style="color: black;">&#93;</span>
K <span style="color: #66cc66;">=</span> <span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#91;</span><span style="color: #ff4500;">4</span><span style="color: black;">&#93;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">print</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"Calculating aproximate temperature for given parameters: k=%s, Tz=%sC, T=%sC, K=%sC"</span> % <span style="color: black;">&#40;</span>k<span style="color: #66cc66;">,</span> Tz<span style="color: #66cc66;">,</span> T<span style="color: #66cc66;">,</span> K<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">print</span><span style="color: black;">&#40;</span>calculation<span style="color: black;">&#40;</span><span style="color: #008000;">float</span><span style="color: black;">&#40;</span>k<span style="color: black;">&#41;</span><span style="color: #66cc66;">,</span> <span style="color: #008000;">float</span><span style="color: black;">&#40;</span>Tz<span style="color: black;">&#41;</span><span style="color: #66cc66;">,</span> <span style="color: #008000;">float</span><span style="color: black;">&#40;</span>T<span style="color: black;">&#41;</span><span style="color: #66cc66;">,</span> <span style="color: #008000;">float</span><span style="color: black;">&#40;</span>K<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span></pre>
      </td>
    </tr>
  </table>
</div>

Enjoy.

And as always,
Thanks for reading!
