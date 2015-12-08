---
title: 'Bitwise & Operator'
author: hannibal
layout: post
date: 2015-07-15
url: /2015/07/15/bitwise-operator/
categories:
  - programming
tags:
  - golang
---
The first, and only time so far, that I got to use the bitwise & operator. I enjoyed doing so!!

And of course from now on, I&#8217;ll be looking for more opportunities to (ab)use it.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="go" style="font-family:monospace;"><span style="color: #b1b100; font-weight: bold;">package</span> secret
&nbsp;
<span style="color: #b1b100; font-weight: bold;">import</span> <span style="color: #cc66cc;">"sort"</span>
&nbsp;
<span style="color: #b1b100; font-weight: bold;">const</span> REVERSE <span style="color: #339933;">=</span> <span style="color: #cc66cc;">16</span>
&nbsp;
<span style="color: #993333;">func</span> Handshake<span style="color: #339933;">(</span>code <span style="color: #993333;">int</span><span style="color: #339933;">)</span> <span style="color: #339933;">[]</span><span style="color: #993333;">string</span> <span style="color: #339933;">{</span>
    <span style="color: #666666; font-style: italic;">// binary_rep := convertDecimalToBinary(code)</span>
    <span style="color: #b1b100; font-weight: bold;">if</span> code &lt; <span style="color: #cc66cc;"></span> <span style="color: #339933;">{</span> <span style="color: #b1b100; font-weight: bold;">return</span> <span style="color: #000000; font-weight: bold;">nil</span> <span style="color: #339933;">}</span>
    secret_map <span style="color: #339933;">:=</span> <span style="color: #993333;">map</span><span style="color: #339933;">[</span><span style="color: #993333;">int</span><span style="color: #339933;">]</span><span style="color: #993333;">string</span> <span style="color: #339933;">{</span>
        <span style="color: #cc66cc;">1</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"wink"</span><span style="color: #339933;">,</span>
        <span style="color: #cc66cc;">2</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"double blink"</span><span style="color: #339933;">,</span>
        <span style="color: #cc66cc;">4</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"close your eyes"</span><span style="color: #339933;">,</span>
        <span style="color: #cc66cc;">8</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"jump"</span><span style="color: #339933;">,</span>
    <span style="color: #339933;">}</span>
&nbsp;
    <span style="color: #b1b100; font-weight: bold;">var</span> keys <span style="color: #339933;">[]</span><span style="color: #993333;">int</span>
    <span style="color: #b1b100; font-weight: bold;">for</span> k <span style="color: #339933;">:=</span> <span style="color: #b1b100; font-weight: bold;">range</span> secret_map <span style="color: #339933;">{</span>
        keys <span style="color: #339933;">=</span> append<span style="color: #339933;">(</span>keys<span style="color: #339933;">,</span> k<span style="color: #339933;">)</span>
    <span style="color: #339933;">}</span>
    <span style="color: #666666; font-style: italic;">// To make sure iteration is always in the same order.</span>
    sort<span style="color: #339933;">.</span>Ints<span style="color: #339933;">(</span>keys<span style="color: #339933;">)</span>
&nbsp;
    code_array <span style="color: #339933;">:=</span> <span style="color: #000066;">make</span><span style="color: #339933;">([]</span><span style="color: #993333;">string</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">)</span>
    <span style="color: #b1b100; font-weight: bold;">for</span> _<span style="color: #339933;">,</span> key <span style="color: #339933;">:=</span> <span style="color: #b1b100; font-weight: bold;">range</span> keys <span style="color: #339933;">{</span>
        <span style="color: #b1b100; font-weight: bold;">if</span> code & key <span style="color: #339933;">==</span> key <span style="color: #339933;">{</span>
            code_array <span style="color: #339933;">=</span> append<span style="color: #339933;">(</span>code_array<span style="color: #339933;">,</span> secret_map<span style="color: #339933;">[</span>key<span style="color: #339933;">])</span>
        <span style="color: #339933;">}</span>
    <span style="color: #339933;">}</span>
&nbsp;
    <span style="color: #b1b100; font-weight: bold;">if</span> code & REVERSE <span style="color: #339933;">==</span> REVERSE <span style="color: #339933;">{</span>
        code_array <span style="color: #339933;">=</span> reverse_array<span style="color: #339933;">(</span>code_array<span style="color: #339933;">)</span>
    <span style="color: #339933;">}</span>
&nbsp;
    <span style="color: #b1b100; font-weight: bold;">return</span> code_array
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> reverse_array <span style="color: #339933;">(</span>array_to_reverse <span style="color: #339933;">[]</span><span style="color: #993333;">string</span><span style="color: #339933;">)</span> <span style="color: #339933;">[]</span><span style="color: #993333;">string</span> <span style="color: #339933;">{</span>
    <span style="color: #b1b100; font-weight: bold;">for</span> <span style="">i</span><span style="color: #339933;">,</span> j <span style="color: #339933;">:=</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">,</span> <span style="color: #000066;">len</span><span style="color: #339933;">(</span>array_to_reverse<span style="color: #339933;">)</span> <span style="color: #339933;">-</span><span style="color: #cc66cc;">1</span> <span style="color: #339933;">;</span> <span style="">i</span> &lt; j<span style="color: #339933;">;</span> <span style="">i</span><span style="color: #339933;">,</span> j <span style="color: #339933;">=</span> <span style="">i</span> <span style="color: #339933;">+</span> <span style="color: #cc66cc;">1</span><span style="color: #339933;">,</span> j <span style="color: #339933;">-</span> <span style="color: #cc66cc;">1</span> <span style="color: #339933;">{</span>
        array_to_reverse<span style="color: #339933;">[</span><span style="">i</span><span style="color: #339933;">],</span> array_to_reverse<span style="color: #339933;">[</span>j<span style="color: #339933;">]</span> <span style="color: #339933;">=</span> array_to_reverse<span style="color: #339933;">[</span>j<span style="color: #339933;">],</span> array_to_reverse<span style="color: #339933;">[</span><span style="">i</span><span style="color: #339933;">]</span>
    <span style="color: #339933;">}</span>
    <span style="color: #b1b100; font-weight: bold;">return</span> array_to_reverse
<span style="color: #339933;">}</span></pre>
      </td>
    </tr>
  </table>
</div>