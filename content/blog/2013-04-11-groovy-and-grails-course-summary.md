+++
author = "hannibal"
categories = ["grails", "groovy", "knowledge", "programming"]
date = "2013-04-11"
type = "post"
title = "Groovy and Grails course summary"
url = "/2013/04/11/groovy-and-grails-course-summary/"

+++

Hi folks.

I attended a 4 day course of Groovy and Grails and this is my attempt at writing up a summary to see how much I retained. I&#8217;ll try to do this from the top of my head without peaking at my notes.

So let&#8217;s begin.

**Introductions**

First of all, introductions. The course was held by Peter Ledbrook. He is the guy who wrote [Grails in Action][1]. He is awesome, go check him out. :: [Twitter][2] ::

The place where it was held is [Skillsmatter][3]. Which of course is known to all, if not, go check them out as well!

**Day One**

Day one and two were about Groovy. We were faced with the quirks and hinges of the language. First tasks were Closures and Currying both of which were really interesting. A bit of functional thinking mixed into the soup.

The course was divided into Peter telling us about stuff for 1:30 hours and then 1:00 hour lab work which really made the whole thing interactive. We could ask questions while he was talking which I&#8217;m sure was very distracting but I hope he is used to it by now. 😉

The tasks which we faced I&#8217;m sure were no real challenge for somebody who was used to thinking with closures and functions. But for us they were very intriguing.

For example:

Convert this class to it&#8217;s groovy eq.

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
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">class</span> NumberHelper <span style="color: #009900;">&#123;</span>
    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000066; font-weight: bold;">int</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span> findPositives<span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">int</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span> numbers<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #003399;">List</span> positivesList <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> <span style="color: #003399;">ArrayList</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #000000; font-weight: bold;">for</span> <span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">int</span> i <span style="color: #339933;">=</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">;</span> i <span style="color: #339933;">&</span>lt<span style="color: #339933;">;</span> numbers.<span style="color: #006633;">length</span><span style="color: #339933;">;</span> i<span style="color: #339933;">++</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            <span style="color: #000000; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>numbers<span style="color: #009900;">&#91;</span>i<span style="color: #009900;">&#93;</span> <span style="color: #339933;">&</span>gt<span style="color: #339933;">;</span> <span style="color: #cc66cc;"></span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                positivesList.<span style="color: #006633;">add</span><span style="color: #009900;">&#40;</span><span style="color: #000000; font-weight: bold;">new</span> <span style="color: #003399;">Integer</span><span style="color: #009900;">&#40;</span>numbers<span style="color: #009900;">&#91;</span>i<span style="color: #009900;">&#93;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            <span style="color: #009900;">&#125;</span>
        <span style="color: #009900;">&#125;</span>
&nbsp;
        <span style="color: #000066; font-weight: bold;">int</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span> positivesArray <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> <span style="color: #000066; font-weight: bold;">int</span><span style="color: #009900;">&#91;</span>positivesList.<span style="color: #006633;">size</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
        <span style="color: #000000; font-weight: bold;">for</span> <span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">int</span> i <span style="color: #339933;">=</span> <span style="color: #cc66cc;"></span><span style="color: #339933;">;</span> i <span style="color: #339933;">&</span>lt<span style="color: #339933;">;</span> positivesArray.<span style="color: #006633;">length</span><span style="color: #339933;">;</span> i<span style="color: #339933;">++</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            positivesArray<span style="color: #009900;">&#91;</span>i<span style="color: #009900;">&#93;</span> <span style="color: #339933;">=</span> <span style="color: #009900;">&#40;</span><span style="color: #009900;">&#40;</span><span style="color: #003399;">Integer</span><span style="color: #009900;">&#41;</span> positivesList.<span style="color: #006633;">get</span><span style="color: #009900;">&#40;</span>i<span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span>.<span style="color: #006633;">intValue</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span>
        <span style="color: #000000; font-weight: bold;">return</span> positivesArray<span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Which basically became:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
2
3
</pre>
      </td>
      
      <td class="code">
        <pre class="groovy" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">def</span> findPositive<span style="color: #66cc66;">&#40;</span><span style="color: #000000; font-weight: bold;">def</span> numbers<span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
    numbers.<span style="color: #663399;">findAll</span><span style="color: #66cc66;">&#40;</span> <span style="color: #66cc66;">&#123;</span> it <span style="color: #66cc66;">&</span>lt<span style="color: #66cc66;">;</span> <span style="color: #cc66cc;"></span> <span style="color: #66cc66;">&#125;</span> <span style="color: #66cc66;">&#41;</span>
<span style="color: #66cc66;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

That&#8217;s pretty damn awesome.

For quite some time now functional languages are re-living their golden age. There are various reasons for that which I won&#8217;t list here. But it has mainly to do with scalability, concurrency and threaded programming. Also the need to eliminate boilerplate code is bigger then ever. I guess people got fed up with Java being so talkative.

So we moved on learning a lot about groovy and its power. We also learned some good practices from Peter what to do and what not to do. For example a line he always repeated is that he hates how a function cannot exist without a class wrapped around it. Another important thing is, which we never ever should forget, that closures are Closures. Which means they aren&#8217;t functions. They are of the type Closure.

And that we shouldn&#8217;t use Closures just because we can. Be sensible. If a method can achieve your task, use a method.

**Day Two**

On day 2 we got into meta-programming. That&#8217;s when the real fun started. Groovy is not only powerful and lightweight it also gives the ability to change its behaviour. Meta programming is sort of a bit new to me. So this was my first definitive intro to it. But I must say that it blew me away. The capabilities are limitless.

There is a class called Expando in groovy which can be used to create virtually anything on the fly what you want.

For example look at this code ::

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
</pre>
      </td>
      
      <td class="code">
        <pre class="groovy" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">def</span> p <span style="color: #66cc66;">=</span> <span style="color: #000000; font-weight: bold;">new</span> Expando<span style="color: #66cc66;">&#40;</span>name: <span style="color: #ff0000;">"Jake"</span>, age: <span style="color: #cc66cc;">24</span><span style="color: #66cc66;">&#41;</span>
<span style="color: #993399;">println</span> p
&nbsp;
<span style="color: #808080; font-style: italic;">//Add properties</span>
p.<span style="color: #006600;">gender</span> <span style="color: #66cc66;">=</span> <span style="color: #ff0000;">"Male"</span>
<span style="color: #993399;">println</span> p.<span style="color: #006600;">name</span>
&nbsp;
<span style="color: #808080; font-style: italic;">//Add metods</span>
<span style="color: #808080; font-style: italic;">//Override the default toString at runtime.</span>
p.<span style="color: #006600;">toString</span> <span style="color: #66cc66;">=</span> <span style="color: #66cc66;">&#123;</span> <span style="color: #66cc66;">-&</span>gt<span style="color: #66cc66;">;</span> <span style="color: #ff0000;">"${name} (${age})"</span> <span style="color: #66cc66;">&#125;</span>
<span style="color: #993399;">println</span> p
&nbsp;
<span style="color: #808080; font-style: italic;">//Learn how groovy resolves names - &gt; How does it find age.</span>
p.<span style="color: #006600;">addYears</span> <span style="color: #66cc66;">=</span> <span style="color: #66cc66;">&#123;</span> years <span style="color: #66cc66;">-&</span>gt<span style="color: #66cc66;">;</span> age <span style="color: #66cc66;">+=</span> years <span style="color: #66cc66;">&#125;</span>
p.<span style="color: #006600;">addYears</span><span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">25</span><span style="color: #66cc66;">&#41;</span>
<span style="color: #993399;">println</span> p</pre>
      </td>
    </tr>
  </table>
</div>

Neat hmm? Just create expando and build up the class as you go however you want to use it.

And you can do this jazz to other, normal classes as well. You can add properties and methods at runtime by implementing the propertyMissing and methodMissing methods. In them afterwards you can specify some custom behaviour you would like to see. By implementing these guys you can directly control what&#8217;s happening to your class. Who is calling it how and where and why.

To grasp the power of metacoding and the abilities with which closures provided us with took a day to properly go over. So we moved on&#8230;

**Day Three**

So groovy was over. The time has come to move on and venture into the foggy land of Grails. Turned out it wasn&#8217;t so foggy after all.

Grails is a rapid prototyping kind of a framework. It allows you to set up an application with a blink of an eye. And provides conventions over configuration which is a really good thing to have. But as the day was going by we realised that we would find ourself not once but many times in the bubbling boils of the underbelly of /conf.

Again, fortunately, it wasn&#8217;t really hard. The config was groovy and it was pretty straight forward too.

Our third day mostly took as off to explore scaffolding, dynamic & static as well, and the interesting land of GORM Peter showed us the power of grails to create a CRUD application with in a matter of seconds / minutes ( depending on how fast your machine is ) with a fairly nice view. These types of application are usually not accepted of course as an end product&#8230; For that you need to thinker a bit here and there.

But things like admin portal are easily put together. So use it often and use it will and get it to know how it works.

In the land of GORM we explored the 4 different possibilities of data retriaval and generally how everything maps together and how GORM work with ORM.

The four different retrieval capabilities are:

  * Where clauses
  * HQL (Hybernate Query Language)
  * Criteria searches
  * Dynamic finder methods

Each of which we found very interesting in there own respective ways.

Example of a dynamic finder::

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="groovy" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">assert</span> Account.<span style="color: #006600;">findAllBy</span><span style="color: #66cc66;">*</span>PropertyName<span style="color: #66cc66;">**</span><span style="color: #aaaadd; font-weight: bold;">Modifier</span><span style="color: #66cc66;">*</span><span style="color: #66cc66;">&#40;</span>Parameters<span style="color: #66cc66;">&#41;</span>.<span style="color: #663399;">size</span> <span style="color: #66cc66;">==</span> <span style="color: #cc66cc;">2</span></pre>
      </td>
    </tr>
  </table>
</div>

Where propertyName is the name of the property to find by, modifier can be a sql&#8217;s Like for example.

So this could become something like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="groovy" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">assert</span> Hitman.<span style="color: #006600;">findAllByNameLike</span><span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"Agent %"</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">==</span> <span style="color: #cc66cc;">15</span></pre>
      </td>
    </tr>
  </table>
</div>

That day was really knowledge packed. I don&#8217;t say I remember everything but luckily I wrote up some notes and I know what and where to look for if I would be in need of something.

**Day Four**

On the last day everybody was pretty much exhausted. It takes a lot to learn all that from 9 to 5 for 4 days. And Peter gave his best to staff that stuff into our heads and as much as possible of it. I think he did a pretty good job.

Last day was all about Controllers, Commands, Models, Views and GSPs and BootStrap config, Environment changes durring start up, the configurability of the whole framework, messages, templates, internationalisation and many thing more which can be easily put together.

It was pretty interesting. GSPs have similarities to JSPs but retained only the good parts. And although you can do JSP stuff in GSPs as well with nice embedded tags you have the ability to actually create a nice page which won&#8217;t be that big a maintenance nightmare.

Peter very much pressed the fact that the Controllers should be your only entry point from HTML requests and the views should be the only output of it. The controllers shouldn&#8217;t be throwing around business logic they should only act as proxies between the outer shell and the inner layering.

I think I understood most of the stuff which we were going through. Again, it was pretty straight forward. The application of it is what need practice.

Durring the course we created several applications. With dynamic scaffolding as well as static. We created and edited our own views and gsps. Created our own Controllers and what nots. One thing is clear. Grails let&#8217;s you progress a hell of a lot in a matter of minutes.

And we were also talking about testing of course. Using Geb, Spock and the unit testing capabilities of Grails. All very powerful stuff. Spock has some impressive Mocking powers in junction with the good ol&#8217; Given When Then structure. If done correctly the test can be very fast and robust.

As final words we talked about plugins and the testing of Views and a bit more configuration.

**Closing words**

So all in all the course was excellent. Peter did a very good job of introducing use to Grails and Groovy. It&#8217;s a very good framework to build upon with a powerful language at our disposal. I&#8217;m pretty certain that Grails will evolve even more and be a great asset to people who choose to develop with it. Handle with Care though. Because no matter how awesome a tool is, it can always be used for bad purposes. 😉

As always,

Thanks for reading and have a nice day / evening.

 [1]: http://www.amazon.co.uk/Grails-Action-Peter-Ledbrook/dp/1617290963/ref=sr_1_2?ie=UTF8&qid=1365713080&sr=8-2&keywords=peter+ledbrook "Grails in Action"
 [2]: https://twitter.com/pledbrook "Twitter for Peter"
 [3]: http://skillsmatter.com/ "Skills Matter"