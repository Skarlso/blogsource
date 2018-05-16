+++
author = "hannibal"
categories = ["java", "knowledge", "problem solving", "programming"]
date = "2012-02-27"
type = "post"
tags = ["configuration", "java"]
title = "Configuration"
url = "/2012/02/27/configuration/"

+++

When I see something like this:

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
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;">    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">class</span> Config <span style="color: #009900;">&#123;</span>
        <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> <span style="color: #000000; font-weight: bold;">final</span> string DATABASELINK <span style="color: #339933;">=</span> <span style="color: #0000ff;">"linkhere"</span><span style="color: #339933;">;</span>
        .
        .
        .
    <span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

It sends a small, but chilling shiver down my spine. Just&#8230; don&#8217;t. There are a lot of possibilities to use configuration in Java. Java property files. Xml. Xml serialization. CSV file. Whatever suits you best, but this? DON&#8217;T!