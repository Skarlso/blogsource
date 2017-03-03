---
title: Small Python GUI to Calculate Lever Distance
author: hannibal
layout: post
date: 2015-04-10
url: /2015/04/10/small-python-gui-to-calculate-lever-distance/
categories:
  - programming
  - Python
tags:
  - mathematics
---
Hi folks.

Just a small script which calculates your distance from a lever focal point if you know your weight, the object&#8217;s weight and the object&#8217;s and the distance the object has from the focal point of the lever.

Like this:

This script will give you D1. And this is how it will look like in doing so:

So, in order for me (77kg) to lift an object of 80kg which is on a, by default, 1 meter long lever, I have to stand back ~1.03meters. Which is totally cool, right?

Here is the code:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #ff7700;font-weight:bold;">from</span> <span style="color: #dc143c;">Tkinter</span> <span style="color: #ff7700;font-weight:bold;">import</span> *
<span style="color: #ff7700;font-weight:bold;">import</span> ttk
&nbsp;
<span style="color: #ff7700;font-weight:bold;">def</span> calculate<span style="color: black;">&#40;</span>*args<span style="color: black;">&#41;</span>:
    <span style="color: #ff7700;font-weight:bold;">try</span>:
        your_weight_value <span style="color: #66cc66;">=</span> <span style="color: #008000;">float</span><span style="color: black;">&#40;</span>your_weight.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
        object_weight_value <span style="color: #66cc66;">=</span> <span style="color: #008000;">float</span><span style="color: black;">&#40;</span>object_weight.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
        object_distance_value <span style="color: #66cc66;">=</span> <span style="color: #008000;">float</span><span style="color: black;">&#40;</span>object_distance.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
        your_distance.<span style="color: #008000;">set</span><span style="color: black;">&#40;</span><span style="color: black;">&#40;</span>object_weight_value * object_distance_value<span style="color: black;">&#41;</span> / your_weight_value<span style="color: black;">&#41;</span>
    <span style="color: #ff7700;font-weight:bold;">except</span> <span style="color: #008000;">ValueError</span>:
        <span style="color: #ff7700;font-weight:bold;">pass</span>
&nbsp;
root <span style="color: #66cc66;">=</span> Tk<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
root.<span style="color: black;">title</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"Lever distance counter"</span><span style="color: black;">&#41;</span>
&nbsp;
mainframe <span style="color: #66cc66;">=</span> ttk.<span style="color: black;">Frame</span><span style="color: black;">&#40;</span>root<span style="color: #66cc66;">,</span> padding<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"4 4 12 12"</span><span style="color: black;">&#41;</span>
mainframe.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;"></span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;"></span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span><span style="color: black;">&#40;</span>N<span style="color: #66cc66;">,</span> W<span style="color: #66cc66;">,</span> E<span style="color: #66cc66;">,</span> S<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
mainframe.<span style="color: black;">columnconfigure</span><span style="color: black;">&#40;</span><span style="color: #ff4500;"></span><span style="color: #66cc66;">,</span> weight<span style="color: #66cc66;">=</span><span style="color: #ff4500;">1</span><span style="color: black;">&#41;</span>
mainframe.<span style="color: black;">rowconfigure</span><span style="color: black;">&#40;</span><span style="color: #ff4500;"></span><span style="color: #66cc66;">,</span> weight<span style="color: #66cc66;">=</span><span style="color: #ff4500;">1</span><span style="color: black;">&#41;</span>
&nbsp;
your_weight <span style="color: #66cc66;">=</span> StringVar<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
object_weight <span style="color: #66cc66;">=</span> StringVar<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
object_distance <span style="color: #66cc66;">=</span> StringVar<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
your_distance <span style="color: #66cc66;">=</span> StringVar<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
&nbsp;
object_distance.<span style="color: #008000;">set</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"1"</span><span style="color: black;">&#41;</span>
&nbsp;
your_weight_entry <span style="color: #66cc66;">=</span> ttk.<span style="color: black;">Entry</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> width<span style="color: #66cc66;">=</span><span style="color: #ff4500;">7</span><span style="color: #66cc66;">,</span> textvariable<span style="color: #66cc66;">=</span>your_weight<span style="color: black;">&#41;</span>
your_weight_entry.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">2</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">1</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span><span style="color: black;">&#40;</span>W<span style="color: #66cc66;">,</span> E<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
object_weight_entry <span style="color: #66cc66;">=</span> ttk.<span style="color: black;">Entry</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> width<span style="color: #66cc66;">=</span><span style="color: #ff4500;">7</span><span style="color: #66cc66;">,</span> textvariable<span style="color: #66cc66;">=</span>object_weight<span style="color: black;">&#41;</span>
object_weight_entry.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">2</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">2</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span><span style="color: black;">&#40;</span>W<span style="color: #66cc66;">,</span> E<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
object_distance_entry <span style="color: #66cc66;">=</span> ttk.<span style="color: black;">Entry</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> width<span style="color: #66cc66;">=</span><span style="color: #ff4500;">7</span><span style="color: #66cc66;">,</span> textvariable<span style="color: #66cc66;">=</span>object_distance<span style="color: black;">&#41;</span>
object_distance_entry.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">2</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">4</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span><span style="color: black;">&#40;</span>W<span style="color: #66cc66;">,</span> E<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
&nbsp;
&nbsp;
ttk.<span style="color: black;">Label</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> textvariable<span style="color: #66cc66;">=</span>your_distance<span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">2</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">3</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span><span style="color: black;">&#40;</span>W<span style="color: #66cc66;">,</span> E<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
ttk.<span style="color: black;">Label</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> text<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"Your weight"</span><span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">1</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">1</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span>W<span style="color: black;">&#41;</span>
ttk.<span style="color: black;">Label</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> text<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"Object weight"</span><span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">1</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">2</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span>W<span style="color: black;">&#41;</span>
ttk.<span style="color: black;">Label</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> text<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"Object Distance"</span><span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">1</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">3</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span>W<span style="color: black;">&#41;</span>
ttk.<span style="color: black;">Label</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> text<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"Your Distance"</span><span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">1</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">4</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span>W<span style="color: black;">&#41;</span>
&nbsp;
ttk.<span style="color: black;">Label</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> text<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"kg"</span><span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">3</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">1</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span>W<span style="color: black;">&#41;</span>
ttk.<span style="color: black;">Label</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> text<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"kg"</span><span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">3</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">2</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span>W<span style="color: black;">&#41;</span>
ttk.<span style="color: black;">Label</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> text<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"m"</span><span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">3</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">3</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span>W<span style="color: black;">&#41;</span>
ttk.<span style="color: black;">Label</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> text<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"m"</span><span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">3</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">4</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span>W<span style="color: black;">&#41;</span>
&nbsp;
ttk.<span style="color: black;">Button</span><span style="color: black;">&#40;</span>mainframe<span style="color: #66cc66;">,</span> text<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"Calculate"</span><span style="color: #66cc66;">,</span> command<span style="color: #66cc66;">=</span>calculate<span style="color: black;">&#41;</span>.<span style="color: black;">grid</span><span style="color: black;">&#40;</span>column<span style="color: #66cc66;">=</span><span style="color: #ff4500;">3</span><span style="color: #66cc66;">,</span> row<span style="color: #66cc66;">=</span><span style="color: #ff4500;">5</span><span style="color: #66cc66;">,</span> sticky<span style="color: #66cc66;">=</span>W<span style="color: black;">&#41;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">for</span> child <span style="color: #ff7700;font-weight:bold;">in</span> mainframe.<span style="color: black;">winfo_children</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>: child.<span style="color: black;">grid_configure</span><span style="color: black;">&#40;</span>padx<span style="color: #66cc66;">=</span><span style="color: #ff4500;">5</span><span style="color: #66cc66;">,</span> pady<span style="color: #66cc66;">=</span><span style="color: #ff4500;">5</span><span style="color: black;">&#41;</span>
&nbsp;
your_weight_entry.<span style="color: black;">focus</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>
root.<span style="color: black;">bind</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">''</span><span style="color: #66cc66;">,</span> calculate<span style="color: black;">&#41;</span>
&nbsp;
root.<span style="color: black;">mainloop</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span></pre>
      </td>
    </tr>
  </table>
</div>

Please enjoy, and feel free to alter in any way. I&#8217;m using Tkinter and a grid layout which I find very easy to work with.

Thanks for reading,
Gergely.
