---
title: TDD and Game of Life
author: hannibal
layout: post
date: 2012-07-12
url: /2012/07/12/tdd-and-game-of-life/
categories:
  - java
  - knowledge
  - problem solving
  - TDD
tags:
  - barcoding
  - game of life
---
So today at 8-12PM I had a great session with two friends of mine. It was awesome. Like a mini code retreat.

We set down in a musky bar, drank wine and beer and cider, and decided to practice some TDD with the well known problem of <a href="http://en.wikipedia.org/wiki/Conway's_Game_of_Life" target="_blank">Conway&#8217;s Game of Life</a>. This challenge is really interesting. I never done it before, ever. So it was a really good practice for me. 

So&#8230;

**In the beginning there was Test**

One of my friends and I started out by developing the implementation for the game while the second one was mentoring and couching us. As with any problem I&#8217;m facing now days, I started with writing a failing test first. I didn&#8217;t write any kind of production code yet. I wrote a test testing for having the class called game of life.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
2
3
4
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;">    @Test
    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000066; font-weight: bold;">void</span> shouldHaveClassForGameOfLife<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        GameOfLife gameOfLife <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> GameOfLife<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

This wasn&#8217;t compiling of course because I didn&#8217;t have any kind of GameOfLife class. But intelliJ is so intelligent that I simply pressed Alt+Enter and created the class immediately. The class didn&#8217;t have anything in it, but I already had a passing test. 

So this went on and on and I created one test after another while my other coding friend did the same. 

**Now the amazing part**

I begun working on the Grid. A simple octagonal coordinating system. This was represented in the beginning with a simple two dimensional array with Cells in it.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;">    Cells<span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span> cells <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> Cells<span style="color: #009900;">&#91;</span><span style="color: #cc66cc;">50</span><span style="color: #009900;">&#93;</span><span style="color: #009900;">&#91;</span><span style="color: #cc66cc;">50</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span></pre>
      </td>
    </tr>
  </table>
</div>

This of course wasn&#8217;t dynamic. I didn&#8217;t care about that yet. I had my grid of cells. These cells were initially all dead. 

Now, the interesting part is that as I developed my Grid finding out the Cells neighbours and counting them, my friend worked on the Cells themselves and getting their next state and killing them based on the rules. 

We never talked to each other, didn&#8217;t agree on roles or directions or anything. And even so at the and&#8230; We were at a stage where we met in the middle and could merge our codes! Our little game of life evolved with a push of a button. ( Three actually. )

This was simply amazing. Without ever talking about the direction we want to go we created a working code base that could be merged! 

**It just works**

Before TDD I would have tackled this problem much differently. And it would have taken me much more time too. This was like an hour or so.

TDD helped me break down the job into small, manageable tasks. I created and deleted and rewrote tests as I went on and on and developed the algorithm for my Grid and Cell. And eventually the problem slowly unfolded itself right before my eyes. I began to see the connections. I began to see the beauty. I began to understand! This is something I rarely enjoyed previously without using TDD. 

**Summary**

I recommend for you guys to do the same. Just sit down, find a problem, find a coding kata and just do it with TDD. With PROPER TDD.

Here are some good sites for katas and problems:
  
<a href="http://codekata.pragprog.com/" target="_blank">http://codekata.pragprog.com/</a>
  
<a href="http://www.spoj.pl/problems/classical/" target="_blank">http://www.spoj.pl/problems/classical/</a>

Just select a problem and then start cracking on it. Do this every time you have some free time. Like a martial art trainee doing basic exercises and you will get better at problem solving and at TDD too. I promise.

Happy coding and good night!
  
Gergely.