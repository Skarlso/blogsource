+++
author = "hannibal"
categories = ["java", "knowledge", "problem solving", "programming", "Uncategorized"]
date = "2012-10-09"
type = "post"
tags = ["pattern"]
title = "How to eliminate a parameter boom"
url = "/2012/10/09/how-to-eliminate-a-parameter-boom/"

+++

Hello folks. 

Today I want to write about a little trick I learned.

If you are working with legacy code and you don&#8217;t have the chance to eliminate core design problems, you can use this little pattern to help you out. 

**Problem**

Problem is that you have a class that has a gazillion collaborators and at some point in time one of the clever devs thought it would be a cool idea to do dependancy injection via the constructor. We all know that doing this makes the class immutable which is very good for a number of reasons. However it doesn&#8217;t provide a flexible solution if you want to leave out one or two collabs. For that your would have to create Adapter constructors and chain them upwards which would get very ugly very fast. While using JavaBeans getters and setters can leave your class in a harmful state like not at all or partially initialised.

So what&#8217;s a good solution then?

**Solution**

One possible solution would be to use some kind of initialisation framework like Springs @Autowired. But cluttering your classes with that isn&#8217;t really pretty either. But it&#8217;s A solution. 

Another solution is the usage of a builder pattern. 

Consider this class:

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
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;">    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">class</span> VeryImportantService <span style="color: #009900;">&#123;</span>
&nbsp;
        <span style="color: #000000; font-weight: bold;">public</span> VeryImportantService<span style="color: #009900;">&#40;</span>CollabOne collabOne, CollabTwo collabTwo, CollabThree collabThree, CollabFour collabFour,
            CollabFive collabFive, CollabSix collabSix<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            .
            .
            .
        <span style="color: #009900;">&#125;</span>
    <span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Don&#8217;t forget that we want these to be optional. I would like to leave out two or three here and there.

The builder let&#8217;s you do that. It looks something like this:

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
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;">    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">class</span> VeryImportantService <span style="color: #009900;">&#123;</span>
&nbsp;
        <span style="color: #000000; font-weight: bold;">private</span> CollabOne collabOne<span style="color: #339933;">;</span>
        <span style="color: #000000; font-weight: bold;">private</span> CollabTwo collabTwo<span style="color: #339933;">;</span>
        <span style="color: #000000; font-weight: bold;">private</span> CollabThree collabThree<span style="color: #339933;">;</span>
        <span style="color: #000000; font-weight: bold;">private</span> CollabFour collabFour<span style="color: #339933;">;</span>
        <span style="color: #000000; font-weight: bold;">private</span> CollabFive collabFive<span style="color: #339933;">;</span>
        <span style="color: #000000; font-weight: bold;">private</span> CollabSix collabSix<span style="color: #339933;">;</span> 
&nbsp;
&nbsp;
        <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> <span style="color: #000000; font-weight: bold;">class</span> Builder<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            <span style="color: #000000; font-weight: bold;">private</span> CollabOne collabOne<span style="color: #339933;">;</span>
            <span style="color: #000000; font-weight: bold;">private</span> CollabTwo collabTwo<span style="color: #339933;">;</span>
            <span style="color: #000000; font-weight: bold;">private</span> CollabThree collabThree<span style="color: #339933;">;</span>
            <span style="color: #000000; font-weight: bold;">private</span> CollabFour collabFour<span style="color: #339933;">;</span>
            <span style="color: #000000; font-weight: bold;">private</span> CollabFive collabFive<span style="color: #339933;">;</span>
            <span style="color: #000000; font-weight: bold;">private</span> CollabSix collabSix<span style="color: #339933;">;</span> 
&nbsp;
            <span style="color: #000000; font-weight: bold;">public</span> Builder<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span><span style="color: #009900;">&#125;</span>
&nbsp;
            <span style="color: #000000; font-weight: bold;">public</span> Builder collabOne<span style="color: #009900;">&#40;</span>CollabOne value<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                <span style="color: #000000; font-weight: bold;">this</span>.<span style="color: #006633;">collabOne</span> <span style="color: #339933;">=</span> value<span style="color: #339933;">;</span>
                <span style="color: #000000; font-weight: bold;">return</span> <span style="color: #000000; font-weight: bold;">this</span><span style="color: #339933;">;</span>
            <span style="color: #009900;">&#125;</span>
&nbsp;
            <span style="color: #000000; font-weight: bold;">public</span> Builder collabTwo<span style="color: #009900;">&#40;</span>CollabTwo value<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                <span style="color: #000000; font-weight: bold;">this</span>.<span style="color: #006633;">collabTwo</span> <span style="color: #339933;">=</span> value<span style="color: #339933;">;</span>
                <span style="color: #000000; font-weight: bold;">return</span> <span style="color: #000000; font-weight: bold;">this</span><span style="color: #339933;">;</span>
            <span style="color: #009900;">&#125;</span>
&nbsp;
            .
            .
            .
&nbsp;
            <span style="color: #000000; font-weight: bold;">public</span> VeryImportantService build<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                <span style="color: #000000; font-weight: bold;">return</span> <span style="color: #000000; font-weight: bold;">new</span> VeryImportantService<span style="color: #009900;">&#40;</span><span style="color: #000000; font-weight: bold;">this</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            <span style="color: #009900;">&#125;</span>
&nbsp;
        <span style="color: #009900;">&#125;</span>
&nbsp;
        <span style="color: #666666; font-style: italic;">//private constructor</span>
        <span style="color: #000000; font-weight: bold;">private</span> VeryImportantService<span style="color: #009900;">&#40;</span>Builder builder<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            <span style="color: #000000; font-weight: bold;">this</span>.<span style="color: #006633;">collabOne</span> <span style="color: #339933;">=</span> builder.<span style="color: #006633;">collabOne</span><span style="color: #339933;">;</span>
            <span style="color: #000000; font-weight: bold;">this</span>.<span style="color: #006633;">collabTwo</span> <span style="color: #339933;">=</span> builder.<span style="color: #006633;">collabTwo</span><span style="color: #339933;">;</span>
            .
            .
            .
        <span style="color: #009900;">&#125;</span>
    <span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Now&#8230; calling this would look something like this:

<pre lang="JAVA" lines="1">VeryImportantService veryImportantService = new VeryImportantService.Builder().collabOne(someValueOne).collabTwo(someValueTwo).collabFive(someValueFive);
</pre>

This enables you to be flexible HOWEVER!! I HATE train wrecks. So I would probably tweak it not to return things, but set them. Then you would end up calling then line by line. Which is still not the best but better then the alternative.

**End words**

So there you go. This is A solution not THE solution obviously. The best would be to NOT design such a monster at all. If you have any better ideas please feel free to share. I would gladly put them on my blog. 

As always,
  
Thanks for reading,
  
Gergely.