---
title: Using Chrome Search Engine – Multiple Search Params
author: hannibal
layout: post
date: 2014-05-18
url: /2014/05/18/using-chrome-search-engine-multiple-search-params/
categories:
  - knowledge
  - programming
  - testing
---
Hello Everybody.

Today I would like to write a few words about Chrome&#8217;s Search Engines.

You&#8217;re probably already using it for a couple of things, like Google, or Amazon searches or YouTube or anything like that. But are you using it to access environments and testing tools faster, with queries?

<!--more-->

For example, here is a quick Jira Search made easy:

Keyword: jira
  
URL: https://atlas.projectname.com/jira/browse/PROJECT-%s

So just type: jira|space|9999

Will immediately bring you to your ticket.

&#8220;Bah, why would I want that?&#8221; &#8211; you ask.

Well, it&#8217;s easy, and quick access, but wait. There is more. How about you want to access a test environment that changes only a number?

Keyword: testenv
  
URL: https://qa%s.projectname.com/testenv

Just type: testenv|space|14

&#8220;Humbug!&#8221; &#8211; you might say. &#8220;What if I have a different URL for an admin site and my main web site AND the number, hmmm? Also I have that stuff bookmarked anyways&#8230;&#8221; &#8211; you might add in.

Well, don&#8217;t fret. By default, Chrome, does not provide this. I know FF does, but I don&#8217;t like FF. That&#8217;s that. So I have to make due with what I have. And indeed there is a solution for using multiple search parameters. It&#8217;s is a JavaScript you can add in into the URL part and Chrome will interpret that. You can find that JavaScript in a few posts but you will find that THAT script is actually Wrong. Here is the **fixed** Script, courtesy of yours truly:

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
</pre>
      </td>
      
      <td class="code">
        <pre class="javascript" style="font-family:monospace;">javascript<span style="color: #339933;">:</span>
<span style="color: #000066; font-weight: bold;">var</span> s<span style="color: #339933;">=</span><span style="color: #3366CC;">'%s'</span><span style="color: #339933;">;</span>
url<span style="color: #339933;">=</span><span style="color: #3366CC;">'https://%s.test%s.projectname.com/'</span><span style="color: #339933;">;</span>
query<span style="color: #339933;">=</span><span style="color: #3366CC;">''</span><span style="color: #339933;">;</span>
urlchunks<span style="color: #339933;">=</span>url.<span style="color: #660066;">split</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">'%s'</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
schunks<span style="color: #339933;">=</span>s.<span style="color: #660066;">split</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">';'</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #000066; font-weight: bold;">for</span><span style="color: #009900;">&#40;</span>i<span style="color: #339933;">=</span><span style="color: #CC0000;"></span><span style="color: #339933;">;</span> i<span style="color: #339933;">&</span>lt<span style="color: #339933;">;</span>urlchunks.<span style="color: #660066;">length</span><span style="color: #339933;">;</span> i<span style="color: #339933;">++</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
	query<span style="color: #339933;">+=</span>urlchunks<span style="color: #009900;">&#91;</span>i<span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
	<span style="color: #000066; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">typeof</span> schunks<span style="color: #009900;">&#91;</span>i<span style="color: #009900;">&#93;</span> <span style="color: #339933;">!=</span> <span style="color: #3366CC;">'undefined'</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
		query<span style="color: #339933;">+=</span>schunks<span style="color: #009900;">&#91;</span>i<span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
	<span style="color: #009900;">&#125;</span>
<span style="color: #009900;">&#125;</span>
location.<span style="color: #660066;">replace</span><span style="color: #009900;">&#40;</span>query<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
      </td>
    </tr>
  </table>
</div>

So no you will have an entry like this:

Keyword: testenv
  
URL: paste in the upper script

And try&#8230; testenv|space|admin;14 => which should result in: https://admin.test14.projectname.com/

The location.replace at the end will bring you to the web page. It&#8217;s interesting to note the s will be replaced by admin;14 which is a nice magic by JavaScript.

**NOTE**: This only works on a page like google.co.uk. For chrome pages, like the new tab, omnibox has this ability disabled unfortunately. <img src="http://ramblingsofaswtester.com/wp-includes/images/smilies/frownie.png" alt=":(" class="wp-smiley" style="height: 1em; max-height: 1em;" />

&#8220;Well then it&#8217;s completely useless, isn&#8217;t it?&#8221; &#8211; you might say. Well, it&#8217;s usage is limited in power, that&#8217;s true. But it&#8217;s still useful as I&#8217;m sure you have a couple of pages open anyways which you don&#8217;t mind using up&#8230;? And you have to remember less keywords only a few powerful ones.

Credit for telling about Chrome Search Engines power in the first place goes to&#8230; \*drumrolls\* => <a href="http://www.testfeed.co.uk/" target="_blank">http://www.testfeed.co.uk/</a>

Anyhow&#8230;
  
As always, thanks for reading.
  
Gergely.