+++
author = "hannibal"
categories = ["Go", "problem solving", "programming"]
date = "2015-10-04"
type = "post"
title = "DataMunger Kata with Go"
url = "/2015/10/04/datamunger-kata-with-go/"

+++

Quickly wrote up the Data Munger code kata in Go.

Next time, I want better abstractions. And a way to select columns based on their header data. For now, this is not bad.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="go" style="font-family:monospace;"><span style="color: #b1b100; font-weight: bold;">package</span> main
&nbsp;
<span style="color: #b1b100; font-weight: bold;">import</span> <span style="color: #339933;">(</span>
	<span style="color: #cc66cc;">"bufio"</span>
	<span style="color: #cc66cc;">"fmt"</span>
	<span style="color: #cc66cc;">"log"</span>
	<span style="color: #cc66cc;">"math"</span>
	<span style="color: #cc66cc;">"os"</span>
	<span style="color: #cc66cc;">"regexp"</span>
	<span style="color: #cc66cc;">"strconv"</span>
	<span style="color: #cc66cc;">"strings"</span>
<span style="color: #339933;">)</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//Data which is Data</span>
<span style="color: #b1b100; font-weight: bold;">type</span> Data <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
	columnName <span style="color: #993333;">string</span>
	compareOne <span style="color: #993333;">float64</span>
	compareTwo <span style="color: #993333;">float64</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> main<span style="color: #339933;">()</span> <span style="color: #339933;">{</span>
	<span style="color: #666666; font-style: italic;">// datas := []Data{WeatherData{}, FootballData{}}</span>
	fmt<span style="color: #339933;">.</span><span style="">Println</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"Minimum weather data:"</span><span style="color: #339933;">,</span> GetDataMinimumDiff<span style="color: #339933;">(</span><span style="color: #cc66cc;">"weather.dat"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">1</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">2</span><span style="color: #339933;">))</span>
	fmt<span style="color: #339933;">.</span>Println<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Minimum football data:"</span><span style="color: #339933;">,</span> GetDataMinimumDiff<span style="color: #339933;">(</span><span style="color: #cc66cc;">"football.dat"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">1</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">6</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">7</span><span style="color: #339933;">))</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//GetDataMinimumDiff gathers data from file to fill up Columns.</span>
<span style="color: #993333;">func</span> GetDataMinimumDiff<span style="color: #339933;">(</span>filename <span style="color: #993333;">string</span><span style="color: #339933;">,</span> nameColumn <span style="color: #993333;">int</span><span style="color: #339933;">,</span> compareColOne <span style="color: #993333;">int</span><span style="color: #339933;">,</span> compareColTwo <span style="color: #993333;">int</span><span style="color: #339933;">)</span> Data <span style="color: #339933;">{</span>
	data <span style="color: #339933;">:=</span> Data<span style="color: #339933;">{}</span>
	minimum <span style="color: #339933;">:=</span> math<span style="color: #339933;">.</span>MaxFloat64
	readLines <span style="color: #339933;">:=</span> ReadFile<span style="color: #339933;">(</span>filename<span style="color: #339933;">)</span>
	<span style="color: #b1b100; font-weight: bold;">for</span> _<span style="color: #339933;">,</span> value <span style="color: #339933;">:=</span> <span style="color: #b1b100; font-weight: bold;">range</span> readLines <span style="color: #339933;">{</span>
		valueArrays <span style="color: #339933;">:=</span> strings<span style="color: #339933;">.</span>Split<span style="color: #339933;">(</span>value<span style="color: #339933;">,</span> <span style="color: #cc66cc;">","</span><span style="color: #339933;">)</span>
		name <span style="color: #339933;">:=</span> valueArrays<span style="color: #339933;">[</span>nameColumn<span style="color: #339933;">]</span>
		trimmedFirst<span style="color: #339933;">,</span> _ <span style="color: #339933;">:=</span> strconv<span style="color: #339933;">.</span>ParseFloat<span style="color: #339933;">(</span>valueArrays<span style="color: #339933;">[</span>compareColOne<span style="color: #339933;">],</span> <span style="color: #cc66cc;">64</span><span style="color: #339933;">)</span>
		trimmedSecond<span style="color: #339933;">,</span> _ <span style="color: #339933;">:=</span> strconv<span style="color: #339933;">.</span>ParseFloat<span style="color: #339933;">(</span>valueArrays<span style="color: #339933;">[</span>compareColTwo<span style="color: #339933;">],</span> <span style="color: #cc66cc;">64</span><span style="color: #339933;">)</span>
		diff <span style="color: #339933;">:=</span> trimmedFirst <span style="color: #339933;">-</span> trimmedSecond
		diff <span style="color: #339933;">=</span> math<span style="color: #339933;">.</span>Abs<span style="color: #339933;">(</span>diff<span style="color: #339933;">)</span>
		<span style="color: #b1b100; font-weight: bold;">if</span> diff &lt;<span style="color: #339933;">=</span> minimum <span style="color: #339933;">{</span>
			minimum <span style="color: #339933;">=</span> diff
			data<span style="color: #339933;">.</span>columnName <span style="color: #339933;">=</span> name
			data<span style="color: #339933;">.</span>compareOne <span style="color: #339933;">=</span> trimmedFirst
			data<span style="color: #339933;">.</span>compareTwo <span style="color: #339933;">=</span> trimmedSecond
		<span style="color: #339933;">}</span>
	<span style="color: #339933;">}</span>
	<span style="color: #b1b100; font-weight: bold;">return</span> data
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//ReadFile reads lines from a file and gives back a string array which contains the lines.</span>
<span style="color: #993333;">func</span> ReadFile<span style="color: #339933;">(</span>fileName <span style="color: #993333;">string</span><span style="color: #339933;">)</span> <span style="color: #339933;">(</span>fileLines <span style="color: #339933;">[]</span><span style="color: #993333;">string</span><span style="color: #339933;">)</span> <span style="color: #339933;">{</span>
	file<span style="color: #339933;">,</span> err <span style="color: #339933;">:=</span> os<span style="color: #339933;">.</span>Open<span style="color: #339933;">(</span>fileName<span style="color: #339933;">)</span>
	<span style="color: #b1b100; font-weight: bold;">if</span> err <span style="color: #339933;">!=</span> <span style="color: #000000; font-weight: bold;">nil</span> <span style="color: #339933;">{</span>
		log<span style="color: #339933;">.</span>Fatal<span style="color: #339933;">(</span>err<span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
	<span style="color: #b1b100; font-weight: bold;">defer</span> file<span style="color: #339933;">.</span>Close<span style="color: #339933;">()</span>
&nbsp;
	scanner <span style="color: #339933;">:=</span> bufio<span style="color: #339933;">.</span>NewScanner<span style="color: #339933;">(</span>file<span style="color: #339933;">)</span>
	<span style="color: #666666; font-style: italic;">//Skipping the first line which is the header.</span>
	scanner<span style="color: #339933;">.</span>Scan<span style="color: #339933;">()</span>
	<span style="color: #b1b100; font-weight: bold;">for</span> scanner<span style="color: #339933;">.</span>Scan<span style="color: #339933;">()</span> <span style="color: #339933;">{</span>
		line <span style="color: #339933;">:=</span> scanner<span style="color: #339933;">.</span>Text<span style="color: #339933;">()</span>
		re <span style="color: #339933;">:=</span> regexp<span style="color: #339933;">.</span>MustCompile<span style="color: #339933;">(</span><span style="color: #cc66cc;">"<span style="color: #000099; font-weight: bold;">\\</span>w+"</span><span style="color: #339933;">)</span>
		lines <span style="color: #339933;">:=</span> re<span style="color: #339933;">.</span>FindAllString<span style="color: #339933;">(</span>line<span style="color: #339933;">,</span> <span style="color: #339933;">-</span><span style="color: #cc66cc;">1</span><span style="color: #339933;">)</span>
		<span style="color: #b1b100; font-weight: bold;">if</span> <span style="color: #000066;">len</span><span style="color: #339933;">(</span>lines<span style="color: #339933;">)</span> &gt; <span style="color: #cc66cc;"></span> <span style="color: #339933;">{</span>
			fileLines <span style="color: #339933;">=</span> append<span style="color: #339933;">(</span>fileLines<span style="color: #339933;">,</span> strings<span style="color: #339933;">.</span>Join<span style="color: #339933;">(</span>lines<span style="color: #339933;">,</span> <span style="color: #cc66cc;">","</span><span style="color: #339933;">))</span>
		<span style="color: #339933;">}</span>
	<span style="color: #339933;">}</span>
&nbsp;
	<span style="color: #b1b100; font-weight: bold;">if</span> err <span style="color: #339933;">:=</span> scanner<span style="color: #339933;">.</span>Err<span style="color: #339933;">();</span> err <span style="color: #339933;">!=</span> <span style="color: #000000; font-weight: bold;">nil</span> <span style="color: #339933;">{</span>
		log<span style="color: #339933;">.</span>Fatal<span style="color: #339933;">(</span>err<span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
&nbsp;
	<span style="color: #b1b100; font-weight: bold;">return</span>
<span style="color: #339933;">}</span></pre>
      </td>
    </tr>
  </table>
</div>