+++
author = "hannibal"
categories = ["problem solving", "programming"]
date = "2015-07-19"
type = "post"
tags = ["golang"]
title = "Converting numbers into string representations"
url = "/2015/07/19/converting-numbers-into-string-representations/"

+++

I quiet like this one. My first go program snippet without any peaking or googling. I&#8217;m proud, though it could be improved with a bit of struct magic and such and such. And it only counts &#8217;till 1000&#8230;

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="go" style="font-family:monospace;"><span style="color: #b1b100; font-weight: bold;">package</span> main
&nbsp;
<span style="color: #b1b100; font-weight: bold;">import</span> <span style="color: #cc66cc;">"fmt"</span>
&nbsp;
<span style="color: #b1b100; font-weight: bold;">var</span> words <span style="color: #339933;">=</span> <span style="color: #993333;">map</span><span style="color: #339933;">[</span><span style="color: #993333;">int</span><span style="color: #339933;">]</span><span style="color: #993333;">string</span><span style="color: #339933;">{</span><span style="color: #cc66cc;">1</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"one"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">2</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"two"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">3</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"three"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">4</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"four"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">5</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"five"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">6</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"six"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">7</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"seven"</span><span style="color: #339933;">,</span>
	<span style="color: #cc66cc;">8</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"eight"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">9</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"nine"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">10</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"ten"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">11</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"eleven"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">12</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"twelve"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">13</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"thirteen"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">14</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"fourteen"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">15</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"fifteen"</span><span style="color: #339933;">,</span>
	<span style="color: #cc66cc;">16</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"sixteen"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">17</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"seventeen"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">18</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"eighteen"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">19</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"nineteen"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">20</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"twenty"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">30</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"thirty"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">40</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"forty"</span><span style="color: #339933;">,</span>
	<span style="color: #cc66cc;">50</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"fifty"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">60</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"sixty"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">70</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"seventy"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">80</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"eighty"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">90</span><span style="color: #339933;">:</span> <span style="color: #cc66cc;">"ninety"</span><span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">// CountLetters count the letters in a long string number representation</span>
<span style="color: #993333;">func</span> CountLetters<span style="color: #339933;">(</span>limit <span style="color: #993333;">int</span><span style="color: #339933;">)</span> <span style="color: #339933;">{</span>
	myLongNumberString <span style="color: #339933;">:=</span> <span style="color: #cc66cc;">""</span>
	<span style="color: #b1b100; font-weight: bold;">for</span> <span style="">i</span> <span style="color: #339933;">:=</span> <span style="color: #cc66cc;">1</span><span style="color: #339933;">;</span> <span style="">i</span> &lt;<span style="color: #339933;">=</span> limit<span style="color: #339933;">;</span> <span style="">i</span><span style="color: #339933;">++</span> <span style="color: #339933;">{</span>
		addLettersToMyString<span style="color: #339933;">(</span>&myLongNumberString<span style="color: #339933;">,</span> <span style="">i</span><span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
	<span style="color: #666666; font-style: italic;">// fmt.Println("1-9 written with letters is: ", len(myLongNumberString))</span>
	fmt<span style="color: #339933;">.</span><span style="">Println</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"The string is:"</span><span style="color: #339933;">,</span> myLongNumberString<span style="color: #339933;">)</span>
	fmt<span style="color: #339933;">.</span><span style="">Println</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"Lenght of string is:"</span><span style="color: #339933;">,</span> <span style="color: #000066;">len</span><span style="color: #339933;">(</span>myLongNumberString<span style="color: #339933;">))</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> addLettersToMyString<span style="color: #339933;">(</span>myString <span style="color: #339933;">*</span><span style="color: #993333;">string</span><span style="color: #339933;">,</span> num <span style="color: #993333;">int</span><span style="color: #339933;">)</span> <span style="color: #339933;">{</span>
	<span style="color: #b1b100; font-weight: bold;">if</span> num &lt; <span style="color: #cc66cc;">20</span> <span style="color: #339933;">{</span>
		<span style="color: #339933;">*</span>myString <span style="color: #339933;">+=</span> words<span style="color: #339933;">[</span>num<span style="color: #339933;">]</span>
	<span style="color: #339933;">}</span>
&nbsp;
	<span style="color: #b1b100; font-weight: bold;">if</span> num &gt;<span style="color: #339933;">=</span> <span style="color: #cc66cc;">20</span> && num &lt; <span style="color: #cc66cc;">100</span> <span style="color: #339933;">{</span>
		<span style="color: #339933;">*</span>myString <span style="color: #339933;">+=</span> countMiddle<span style="color: #339933;">(</span>num<span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
&nbsp;
	<span style="color: #b1b100; font-weight: bold;">if</span> num &gt;<span style="color: #339933;">=</span> <span style="color: #cc66cc;">100</span> && num &lt; <span style="color: #cc66cc;">1000</span> <span style="color: #339933;">{</span>
		hundred<span style="color: #339933;">,</span> tenth <span style="color: #339933;">:=</span> countHundred<span style="color: #339933;">(</span>num<span style="color: #339933;">)</span>
		<span style="color: #b1b100; font-weight: bold;">if</span> tenth <span style="color: #339933;">==</span> <span style="color: #cc66cc;"></span> <span style="color: #339933;">{</span>
			<span style="color: #339933;">*</span>myString <span style="color: #339933;">+=</span> hundred
		<span style="color: #339933;">}</span> <span style="color: #b1b100; font-weight: bold;">else</span> <span style="color: #b1b100; font-weight: bold;">if</span> tenth &gt;<span style="color: #339933;">=</span> <span style="color: #cc66cc;">11</span> && tenth &lt; <span style="color: #cc66cc;">20</span> <span style="color: #339933;">{</span>
			<span style="color: #339933;">*</span>myString <span style="color: #339933;">+=</span> hundred <span style="color: #339933;">+</span> <span style="color: #cc66cc;">"and"</span> <span style="color: #339933;">+</span> words<span style="color: #339933;">[</span>tenth<span style="color: #339933;">]</span>
		<span style="color: #339933;">}</span> <span style="color: #b1b100; font-weight: bold;">else</span> <span style="color: #339933;">{</span>
			<span style="color: #339933;">*</span>myString <span style="color: #339933;">+=</span> hundred <span style="color: #339933;">+</span> <span style="color: #cc66cc;">"and"</span> <span style="color: #339933;">+</span> countMiddle<span style="color: #339933;">(</span>tenth<span style="color: #339933;">)</span>
		<span style="color: #339933;">}</span>
&nbsp;
	<span style="color: #339933;">}</span>
&nbsp;
	<span style="color: #b1b100; font-weight: bold;">if</span> num <span style="color: #339933;">==</span> <span style="color: #cc66cc;">1000</span> <span style="color: #339933;">{</span>
		<span style="color: #339933;">*</span>myString <span style="color: #339933;">+=</span> <span style="color: #cc66cc;">"onethousand"</span>
	<span style="color: #339933;">}</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> countMiddle<span style="color: #339933;">(</span>num <span style="color: #993333;">int</span><span style="color: #339933;">)</span> <span style="color: #993333;">string</span> <span style="color: #339933;">{</span>
	minues <span style="color: #339933;">:=</span> num <span style="color: #339933;">%</span> <span style="color: #cc66cc;">10</span>
	num <span style="color: #339933;">-=</span> minues
	<span style="color: #b1b100; font-weight: bold;">return</span> words<span style="color: #339933;">[</span>num<span style="color: #339933;">]</span> <span style="color: #339933;">+</span> words<span style="color: #339933;">[</span>minues<span style="color: #339933;">]</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> countHundred<span style="color: #339933;">(</span>num <span style="color: #993333;">int</span><span style="color: #339933;">)</span> <span style="color: #339933;">(</span><span style="color: #993333;">string</span><span style="color: #339933;">,</span> <span style="color: #993333;">int</span><span style="color: #339933;">)</span> <span style="color: #339933;">{</span>
	minues <span style="color: #339933;">:=</span> num <span style="color: #339933;">%</span> <span style="color: #cc66cc;">100</span>
	num <span style="color: #339933;">-=</span> minues
	<span style="color: #b1b100; font-weight: bold;">return</span> <span style="color: #339933;">(</span>words<span style="color: #339933;">[(</span>num<span style="color: #339933;">/</span><span style="color: #cc66cc;">100</span><span style="color: #339933;">)]</span> <span style="color: #339933;">+</span> <span style="color: #cc66cc;">"hundred"</span><span style="color: #339933;">),</span> minues
<span style="color: #339933;">}</span></pre>
      </td>
    </tr>
  </table>
</div>