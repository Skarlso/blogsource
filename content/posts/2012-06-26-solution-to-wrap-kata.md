---
title: Solution to Wrap Kata
author: hannibal
layout: post
date: 2012-06-26
url: /2012/06/26/solution-to-wrap-kata/
categories:
  - java
  - knowledge
  - problem solving
  - programming
tags:
  - coding kata
---
My solution to the String Wrap Kata. The goal is to have it wrap a text on a given column width.

It is not the best solution but this is my first try. I did it with TDD so there were tests first, which I&#8217;m not going to copy in..

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;">&nbsp;
<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">class</span> WrapKata <span style="color: #009900;">&#123;</span>
&nbsp;
    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #003399;">String</span> wrap<span style="color: #009900;">&#40;</span><span style="color: #003399;">String</span> input, <span style="color: #000066; font-weight: bold;">int</span> columnSize<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
&nbsp;
        <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>input.<span style="color: #006633;">length</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #339933;">&lt;=</span> columnSize<span style="color: #009900;">&#41;</span>
            <span style="color: #000000; font-weight: bold;">return</span> input<span style="color: #339933;">;</span>
        <span style="color: #000000; font-weight: bold;">else</span> <span style="color: #009900;">&#123;</span>
            <span style="color: #000000; font-weight: bold;">return</span> wrapLines<span style="color: #009900;">&#40;</span>input, columnSize<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span>
    <span style="color: #009900;">&#125;</span>
&nbsp;
    <span style="color: #000000; font-weight: bold;">private</span> <span style="color: #003399;">String</span> wrapLines<span style="color: #009900;">&#40;</span><span style="color: #003399;">String</span> input, <span style="color: #000066; font-weight: bold;">int</span> columnSize<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #000066; font-weight: bold;">int</span> breakPoint <span style="color: #339933;">=</span> getBreakPoint<span style="color: #009900;">&#40;</span>input, columnSize<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
        <span style="color: #003399;">String</span> head <span style="color: #339933;">=</span> createHead<span style="color: #009900;">&#40;</span>input, breakPoint<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #003399;">String</span> tail <span style="color: #339933;">=</span> createTail<span style="color: #009900;">&#40;</span>input, breakPoint<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
        <span style="color: #000000; font-weight: bold;">return</span> head <span style="color: #339933;">+=</span> <span style="color: #0000ff;">"<span style="color: #000099; font-weight: bold;">\n</span>"</span> <span style="color: #339933;">+</span> wrap<span style="color: #009900;">&#40;</span>tail, columnSize<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
&nbsp;
    <span style="color: #000000; font-weight: bold;">private</span> <span style="color: #003399;">String</span> createTail<span style="color: #009900;">&#40;</span><span style="color: #003399;">String</span> input, <span style="color: #000066; font-weight: bold;">int</span> breakPoint<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #000000; font-weight: bold;">return</span> input.<span style="color: #006633;">substring</span><span style="color: #009900;">&#40;</span>breakPoint<span style="color: #009900;">&#41;</span>.<span style="color: #006633;">trim</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
&nbsp;
    <span style="color: #000000; font-weight: bold;">private</span> <span style="color: #003399;">String</span> createHead<span style="color: #009900;">&#40;</span><span style="color: #003399;">String</span> input, <span style="color: #000066; font-weight: bold;">int</span> breakPoint<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #000000; font-weight: bold;">return</span> input.<span style="color: #006633;">substring</span><span style="color: #009900;">&#40;</span><span style="color: #cc66cc;"></span>, breakPoint<span style="color: #009900;">&#41;</span>.<span style="color: #006633;">trim</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
&nbsp;
    <span style="color: #000000; font-weight: bold;">private</span> <span style="color: #000066; font-weight: bold;">int</span> getBreakPoint<span style="color: #009900;">&#40;</span><span style="color: #003399;">String</span> input, <span style="color: #000066; font-weight: bold;">int</span> columnSize<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>input.<span style="color: #006633;">contains</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">" "</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            <span style="color: #000000; font-weight: bold;">return</span> input.<span style="color: #006633;">lastIndexOf</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">' '</span>, columnSize<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span> <span style="color: #000000; font-weight: bold;">else</span> <span style="color: #009900;">&#123;</span>
            <span style="color: #000000; font-weight: bold;">return</span> columnSize<span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span>
    <span style="color: #009900;">&#125;</span>
<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>