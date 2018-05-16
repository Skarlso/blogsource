+++
author = "hannibal"
categories = ["Go", "problem solving", "programming"]
date = "2015-10-15"
type = "post"
title = "Circular buffer in Go"
url = "/2015/10/15/circular-buffer-in-go/"

+++

I&#8217;m proud of this one too. No peaking. I like how go let&#8217;s you do this kind of stuff in a very nice way.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="go" style="font-family:monospace;"><span style="color: #b1b100; font-weight: bold;">package</span> circular
&nbsp;
<span style="color: #b1b100; font-weight: bold;">import</span> <span style="color: #cc66cc;">"fmt"</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//TestVersion testVersion</span>
<span style="color: #b1b100; font-weight: bold;">const</span> TestVersion <span style="color: #339933;">=</span> <span style="color: #cc66cc;">1</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//Buffer buffer type</span>
<span style="color: #b1b100; font-weight: bold;">type</span> Buffer <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
    buffer <span style="color: #339933;">[]</span><span style="color: #993333;">byte</span>
    full   <span style="color: #993333;">int</span>
    size   <span style="color: #993333;">int</span>
    s<span style="color: #339933;">,</span> e   <span style="color: #993333;">int</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//NewBuffer creates a new Buffer</span>
<span style="color: #993333;">func</span> NewBuffer<span style="color: #339933;">(</span>size <span style="color: #993333;">int</span><span style="color: #339933;">)</span> <span style="color: #339933;">*</span>Buffer <span style="color: #339933;">{</span>
    <span style="color: #b1b100; font-weight: bold;">return</span> &Buffer<span style="color: #339933;">{</span>buffer<span style="color: #339933;">:</span> <span style="color: #000066;">make</span><span style="color: #339933;">([]</span><span style="color: #993333;">byte</span><span style="color: #339933;">,</span> size<span style="color: #339933;">),</span> s<span style="color: #339933;">:</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">,</span> e<span style="color: #339933;">:</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">,</span> size<span style="color: #339933;">:</span> size<span style="color: #339933;">,</span> full<span style="color: #339933;">:</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">}</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//ReadByte reads a byte from b Buffer</span>
<span style="color: #993333;">func</span> <span style="color: #339933;">(</span>b <span style="color: #339933;">*</span>Buffer<span style="color: #339933;">)</span> ReadByte<span style="color: #339933;">()</span> <span style="color: #339933;">(</span><span style="color: #993333;">byte</span><span style="color: #339933;">,</span> error<span style="color: #339933;">)</span> <span style="color: #339933;">{</span>
    <span style="color: #b1b100; font-weight: bold;">if</span> b<span style="color: #339933;">.</span>full <span style="color: #339933;">==</span> <span style="color: #cc66cc;"></span> <span style="color: #339933;">{</span>
        <span style="color: #b1b100; font-weight: bold;">return</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">,</span> fmt<span style="color: #339933;">.</span>Errorf<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Danger Will Robinson: %s"</span><span style="color: #339933;">,</span> b<span style="color: #339933;">)</span>
    <span style="color: #339933;">}</span>
    readByte <span style="color: #339933;">:=</span> b<span style="color: #339933;">.</span>buffer<span style="color: #339933;">[</span>b<span style="color: #339933;">.</span>s<span style="color: #339933;">]</span>
    b<span style="color: #339933;">.</span>s <span style="color: #339933;">=</span> <span style="color: #339933;">(</span>b<span style="color: #339933;">.</span>s <span style="color: #339933;">+</span> <span style="color: #cc66cc;">1</span><span style="color: #339933;">)</span> <span style="color: #339933;">%</span> b<span style="color: #339933;">.</span>size
    b<span style="color: #339933;">.</span>full<span style="color: #339933;">--</span>
    <span style="color: #b1b100; font-weight: bold;">return</span> readByte<span style="color: #339933;">,</span> <span style="color: #000000; font-weight: bold;">nil</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//WriteByte writes c byte to the buffer</span>
<span style="color: #993333;">func</span> <span style="color: #339933;">(</span>b <span style="color: #339933;">*</span>Buffer<span style="color: #339933;">)</span> WriteByte<span style="color: #339933;">(</span>c <span style="color: #993333;">byte</span><span style="color: #339933;">)</span> error <span style="color: #339933;">{</span>
    <span style="color: #b1b100; font-weight: bold;">if</span> b<span style="color: #339933;">.</span>full<span style="color: #339933;">+</span><span style="color: #cc66cc;">1</span> &gt; b<span style="color: #339933;">.</span>size <span style="color: #339933;">{</span>
        <span style="color: #b1b100; font-weight: bold;">return</span> fmt<span style="color: #339933;">.</span>Errorf<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Danger Will Robinson: %s"</span><span style="color: #339933;">,</span> b<span style="color: #339933;">)</span>
    <span style="color: #339933;">}</span>
    b<span style="color: #339933;">.</span>buffer<span style="color: #339933;">[</span>b<span style="color: #339933;">.</span>e<span style="color: #339933;">]</span> <span style="color: #339933;">=</span> c
    b<span style="color: #339933;">.</span>e <span style="color: #339933;">=</span> <span style="color: #339933;">(</span>b<span style="color: #339933;">.</span>e <span style="color: #339933;">+</span> <span style="color: #cc66cc;">1</span><span style="color: #339933;">)</span> <span style="color: #339933;">%</span> b<span style="color: #339933;">.</span>size
    b<span style="color: #339933;">.</span>full<span style="color: #339933;">++</span>
    <span style="color: #b1b100; font-weight: bold;">return</span> <span style="color: #000000; font-weight: bold;">nil</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//Overwrite overwrites the oldest byte in Buffer</span>
<span style="color: #993333;">func</span> <span style="color: #339933;">(</span>b <span style="color: #339933;">*</span>Buffer<span style="color: #339933;">)</span> Overwrite<span style="color: #339933;">(</span>c <span style="color: #993333;">byte</span><span style="color: #339933;">)</span> <span style="color: #339933;">{</span>
    b<span style="color: #339933;">.</span>buffer<span style="color: #339933;">[</span>b<span style="color: #339933;">.</span>s<span style="color: #339933;">]</span> <span style="color: #339933;">=</span> c
    b<span style="color: #339933;">.</span>s <span style="color: #339933;">=</span> <span style="color: #339933;">(</span>b<span style="color: #339933;">.</span>s <span style="color: #339933;">+</span> <span style="color: #cc66cc;">1</span><span style="color: #339933;">)</span> <span style="color: #339933;">%</span> b<span style="color: #339933;">.</span>size
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//Reset resets the buffer</span>
<span style="color: #993333;">func</span> <span style="color: #339933;">(</span>b <span style="color: #339933;">*</span>Buffer<span style="color: #339933;">)</span> Reset<span style="color: #339933;">()</span> <span style="color: #339933;">{</span>
    <span style="color: #339933;">*</span>b <span style="color: #339933;">=</span> <span style="color: #339933;">*</span>NewBuffer<span style="color: #339933;">(</span>b<span style="color: #339933;">.</span>size<span style="color: #339933;">)</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//String for a string representation of Buffer</span>
<span style="color: #993333;">func</span> <span style="color: #339933;">(</span>b <span style="color: #339933;">*</span>Buffer<span style="color: #339933;">)</span> String<span style="color: #339933;">()</span> <span style="color: #993333;">string</span> <span style="color: #339933;">{</span>
    <span style="color: #b1b100; font-weight: bold;">return</span> fmt<span style="color: #339933;">.</span>Sprintf<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Buffer: %d, %d, %d, %d"</span><span style="color: #339933;">,</span> b<span style="color: #339933;">.</span><span style="">buffer</span><span style="color: #339933;">,</span> b<span style="color: #339933;">.</span><span style="">s</span><span style="color: #339933;">,</span> b<span style="color: #339933;">.</span><span style="">e</span><span style="color: #339933;">,</span> b<span style="color: #339933;">.</span><span style="">size</span><span style="color: #339933;">)</span>
<span style="color: #339933;">}</span></pre>
      </td>
    </tr>
  </table>
</div>