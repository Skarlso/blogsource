---
title: Cucumber-Jvm And @AfterAll
author: hannibal
layout: post
date: 2013-04-18
url: /2013/04/18/cucumber-jvm-and-afterall/
categories:
  - java
  - problem solving
  - testing
tags:
  - cucumber-jm
---
Hey folks.

I find out something new about cucumber-jvm every day. 

If you want something that is executed after all of the tests have finished you must use the Java shutdownHook. It&#8217;s simple really you add in a block of code that can run right before the JVM quits. I know I know&#8230; It sounds awful but I found out that this is the actual way of doing this with java / cucumber.

Anyways&#8230; 

Here is something to do when all of your test quit->

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="java" style="font-family:monospace;">    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> <span style="color: #000066; font-weight: bold;">void</span> attachShutDownHook<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#123;</span>
        <span style="color: #003399;">Runtime</span>.<span style="color: #006633;">getRuntime</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>.<span style="color: #006633;">addShutdownHook</span><span style="color: #009900;">&#40;</span><span style="color: #000000; font-weight: bold;">new</span> <span style="color: #003399;">Thread</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            @Override
            <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000066; font-weight: bold;">void</span> run<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                <span style="color: #003399;">Properties</span> properties <span style="color: #339933;">=</span> <span style="color: #003399;">System</span>.<span style="color: #006633;">getProperties</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
                <span style="color: #003399;">String</span> filename <span style="color: #339933;">=</span> properties.<span style="color: #006633;">getProperty</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"filename"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
                <span style="color: #003399;">String</span> path <span style="color: #339933;">=</span> properties.<span style="color: #006633;">getProperty</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"path"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
                List<span style="color: #339933;">&lt;</span>Story<span style="color: #339933;">&gt;</span> stories <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> ArrayList<span style="color: #339933;">&lt;&gt;</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
                Path file <span style="color: #339933;">=</span> Paths.<span style="color: #006633;">get</span><span style="color: #009900;">&#40;</span>path <span style="color: #339933;">+</span> filename<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
                <span style="color: #000000; font-weight: bold;">try</span> <span style="color: #009900;">&#123;</span>
                    <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>Files.<span style="color: #006633;">exists</span><span style="color: #009900;">&#40;</span>file<span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                        List<span style="color: #339933;">&lt;</span>String<span style="color: #339933;">&gt;</span> lines <span style="color: #339933;">=</span> Files.<span style="color: #006633;">readAllLines</span><span style="color: #009900;">&#40;</span>file, Charset.<span style="color: #006633;">defaultCharset</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
                        <span style="color: #000000; font-weight: bold;">for</span> <span style="color: #009900;">&#40;</span><span style="color: #003399;">String</span> line <span style="color: #339933;">:</span> lines<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                            <span style="color: #666666; font-style: italic;">//add file lines to a report here</span>
                        <span style="color: #009900;">&#125;</span>
                    <span style="color: #009900;">&#125;</span>
                <span style="color: #009900;">&#125;</span> <span style="color: #000000; font-weight: bold;">catch</span> <span style="color: #009900;">&#40;</span><span style="color: #003399;">IOException</span> e<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                    logger.<span style="color: #006633;">error</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"Exception occurred: "</span> <span style="color: #339933;">+</span> e.<span style="color: #006633;">getLocalizedMessage</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
                <span style="color: #009900;">&#125;</span>
                    <span style="color: #666666; font-style: italic;">//send report to a remote location here</span>
                    <span style="color: #666666; font-style: italic;">//since this is a shutdown hook this should take only a few seconds.</span>
            <span style="color: #009900;">&#125;</span>
        <span style="color: #009900;">&#125;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        logger.<span style="color: #006633;">infor</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"Shut Down Hook Attached."</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

So there you go. You would need to call this in a @BeforeClass to have it attached. This is a small hook attached after each test has run which would submit a report built up from a file. Why not use a listener or a custom report generator or whatever? Because maybe you have the report done in a remote place where you need to place a csv file which will be available to everybody to look at. And you want the report to be sent and generated dynamically. Or you have some clean up to do after your suit is done.

In ruby the @AfterAll is actually equivalent to this which in ruby land would be at_exit.

For example:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="ruby" style="font-family:monospace;">  <span style="color:#CC0066; font-weight:bold;">at_exit</span> <span style="color:#9966CC; font-weight:bold;">do</span>
    <span style="color:#008000; font-style:italic;"># Global teardown</span>
    TempFileManager.<span style="color:#9900CC;">clean_up</span>
  <span style="color:#9966CC; font-weight:bold;">end</span></pre>
      </td>
    </tr>
  </table>
</div>

So there it is. Hope this helped. 

Cheers,
  
And as always,
  
Have a nice day!
  
G.