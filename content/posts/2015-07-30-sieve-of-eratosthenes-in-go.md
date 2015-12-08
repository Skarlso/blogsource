---
title: Sieve of Eratosthenes in Go
author: hannibal
layout: post
date: 2015-07-30
url: /2015/07/30/sieve-of-eratosthenes-in-go/
categories:
  - Go
  - problem solving
  - programming
---
I&#8217;m pretty proud of this one as well.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="go" style="font-family:monospace;"><span style="color: #b1b100; font-weight: bold;">package</span> sieve
&nbsp;
<span style="color: #666666; font-style: italic;">//Sieve Uses the Sieve of Eratosthenes to calculate primes to a certain limit</span>
<span style="color: #993333;">func</span> Sieve<span style="color: #339933;">(</span>limit <span style="color: #993333;">int</span><span style="color: #339933;">)</span> <span style="color: #339933;">[]</span><span style="color: #993333;">int</span> <span style="color: #339933;">{</span>
	<span style="color: #b1b100; font-weight: bold;">var</span> listOfPrimes <span style="color: #339933;">[]</span><span style="color: #993333;">int</span>
	markers <span style="color: #339933;">:=</span> <span style="color: #000066;">make</span><span style="color: #339933;">([]</span><span style="color: #993333;">bool</span><span style="color: #339933;">,</span> limit<span style="color: #339933;">)</span>
&nbsp;
	<span style="color: #b1b100; font-weight: bold;">for</span> <span style="">i</span> <span style="color: #339933;">:=</span> <span style="color: #cc66cc;">2</span><span style="color: #339933;">;</span> <span style="">i</span> &lt; limit<span style="color: #339933;">;</span> <span style="">i</span><span style="color: #339933;">++</span> <span style="color: #339933;">{</span>
		<span style="color: #b1b100; font-weight: bold;">if</span> <span style="color: #339933;">!</span>markers<span style="color: #339933;">[</span><span style="">i</span><span style="color: #339933;">]</span> <span style="color: #339933;">{</span>
			<span style="color: #b1b100; font-weight: bold;">for</span> j <span style="color: #339933;">:=</span> <span style="">i</span> <span style="color: #339933;">+</span> <span style="">i</span><span style="color: #339933;">;</span> j &lt; limit<span style="color: #339933;">;</span> j <span style="color: #339933;">+=</span> <span style="">i</span> <span style="color: #339933;">{</span>
				markers<span style="color: #339933;">[</span>j<span style="color: #339933;">]</span> <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">true</span>
			<span style="color: #339933;">}</span>
			listOfPrimes <span style="color: #339933;">=</span> append<span style="color: #339933;">(</span>listOfPrimes<span style="color: #339933;">,</span> <span style="">i</span><span style="color: #339933;">)</span>
		<span style="color: #339933;">}</span>
	<span style="color: #339933;">}</span>
&nbsp;
	<span style="color: #b1b100; font-weight: bold;">return</span> listOfPrimes
<span style="color: #339933;">}</span></pre>
      </td>
    </tr>
  </table>
</div>