+++
author = "hannibal"
categories = ["java", "problem solving", "programming"]
date = "2014-02-19"
type = "post"
tags = ["Design Patterns"]
title = "Example when to use the Strategy Pattern"
url = "/2014/02/19/example-when-to-use-the-strategy-pattern/"

+++

Hello folks.

A quick post about an interesting idea.

I want to elaborate on a possibility to use the Strategy Design pattern.

<!--more-->

There are many clues that you need one. One is for example if your object has a boolean variable which you use a lot in other classes to determine behavior. Then there is perhaps time to implement a Strategy.

Example:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="java" style="font-family:monospace;">	<span style="color: #000000; font-weight: bold;">class</span> SomeClass <span style="color: #009900;">&#123;</span>
		<span style="color: #000000; font-weight: bold;">private</span> <span style="color: #000066; font-weight: bold;">boolean</span> stateChange <span style="color: #339933;">=</span> <span style="color: #000066; font-weight: bold;">false</span><span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> SomeClass <span style="color: #009900;">&#40;</span>stateChange<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">this</span>.<span style="color: #006633;">stateChange</span> <span style="color: #339933;">=</span> stateChange<span style="color: #339933;">;</span> 
		<span style="color: #009900;">&#125;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000066; font-weight: bold;">boolean</span> getStateChange<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">return</span> stateChange<span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #000000; font-weight: bold;">class</span> SomeUserClass <span style="color: #009900;">&#123;</span>
		<span style="color: #000000; font-weight: bold;">private</span> SomeClass foo<span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> SomeUserClass<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			foo <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> SomeClass<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #003399;">String</span> someMethod<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>foo.<span style="color: #006633;">getStateChange</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
				<span style="color: #000000; font-weight: bold;">return</span> <span style="color: #0000ff;">"Some string"</span><span style="color: #339933;">;</span>
			<span style="color: #009900;">&#125;</span> <span style="color: #000000; font-weight: bold;">else</span> <span style="color: #009900;">&#123;</span>
				<span style="color: #000000; font-weight: bold;">return</span> <span style="color: #0000ff;">"Some string else"</span><span style="color: #339933;">;</span>
			<span style="color: #009900;">&#125;</span>
		<span style="color: #009900;">&#125;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #000000; font-weight: bold;">class</span> SomeOtherUserClass <span style="color: #009900;">&#123;</span>
		<span style="color: #000000; font-weight: bold;">private</span> SomeClass foo<span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> SomeOtherUserClass<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			foo <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> SomeClass<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #003399;">String</span> someMethodTwo<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>foo.<span style="color: #006633;">getStateChange</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
				<span style="color: #000000; font-weight: bold;">return</span> <span style="color: #0000ff;">"Some string"</span><span style="color: #339933;">;</span>
			<span style="color: #009900;">&#125;</span> <span style="color: #000000; font-weight: bold;">else</span> <span style="color: #009900;">&#123;</span>
				<span style="color: #000000; font-weight: bold;">return</span> <span style="color: #0000ff;">"Some string else"</span><span style="color: #339933;">;</span>
			<span style="color: #009900;">&#125;</span>
		<span style="color: #009900;">&#125;</span>
	<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

So you have two classes which do something based on some boolean coming from a class. So what you can do in this case, simply extract out that change in state.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="java" style="font-family:monospace;">&nbsp;
	<span style="color: #000000; font-weight: bold;">class</span> Foo <span style="color: #000000; font-weight: bold;">implements</span> Base <span style="color: #009900;">&#123;</span>
		<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #003399;">String</span> getMyString<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">return</span> <span style="color: #0000ff;">"Some string"</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #000000; font-weight: bold;">class</span> Bar <span style="color: #000000; font-weight: bold;">implements</span> Base <span style="color: #009900;">&#123;</span>
		<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #003399;">String</span> getMyString<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">return</span> <span style="color: #0000ff;">"Some string else"</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #000000; font-weight: bold;">interface</span> Base <span style="color: #009900;">&#123;</span>
		<span style="color: #003399;">String</span> getMyString<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #000000; font-weight: bold;">class</span> FooStrategy <span style="color: #009900;">&#123;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> Base getMeAClass<span style="color: #009900;">&#40;</span><span style="color: #000000; font-weight: bold;">enum</span> classChooser<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">switch</span> classChooser <span style="color: #009900;">&#123;</span>
				<span style="color: #000000; font-weight: bold;">case</span> classChooser.<span style="color: #006633;">FOO</span> <span style="color: #339933;">:</span> <span style="color: #000000; font-weight: bold;">return</span> <span style="color: #000000; font-weight: bold;">new</span> Foo<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span> <span style="color: #000000; font-weight: bold;">break</span><span style="color: #339933;">;</span>
				<span style="color: #000000; font-weight: bold;">case</span> classChooser.<span style="color: #006633;">BAR</span> <span style="color: #339933;">:</span> <span style="color: #000000; font-weight: bold;">return</span> <span style="color: #000000; font-weight: bold;">new</span> Bar<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span> <span style="color: #000000; font-weight: bold;">break</span><span style="color: #339933;">;</span>
				<span style="color: #000000; font-weight: bold;">default</span> <span style="color: #339933;">:</span> <span style="color: #000066; font-weight: bold;">null</span><span style="color: #339933;">;</span> <span style="color: #666666; font-style: italic;">//yeah yeah I know but I'm writing this in notepad... :)</span>
			<span style="color: #009900;">&#125;</span>
		<span style="color: #009900;">&#125;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #000000; font-weight: bold;">class</span> SomeUserClass <span style="color: #009900;">&#123;</span>
		<span style="color: #000000; font-weight: bold;">private</span> Base foo<span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> SomeUserClass<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			foo <span style="color: #339933;">=</span> FooStrategy.<span style="color: #006633;">getMeAClass</span><span style="color: #009900;">&#40;</span>ClassChooser.<span style="color: #006633;">FOO</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #003399;">String</span> someMethod<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">return</span> foo.<span style="color: #006633;">getMyString</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #000000; font-weight: bold;">class</span> SomeOtherUserClass <span style="color: #009900;">&#123;</span>
		<span style="color: #000000; font-weight: bold;">private</span> Base bar<span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> SomeUserClass<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			bar <span style="color: #339933;">=</span> FooStrategy.<span style="color: #006633;">getMeAClass</span><span style="color: #009900;">&#40;</span>ClassChooser.<span style="color: #006633;">BAR</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #003399;">String</span> someMethod<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">return</span> bar.<span style="color: #006633;">getMyString</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
	<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Now I know this looks like a lot of more code. However imagine this on a much larger scale with lots of implementations for Foo and Bar. Your if statements will get very convulated very quickly. This way you abstract away the choice into a Factory. And you can add as many implementations of Base as you like with as many variants as you like without changing the logic anywhere else but the Factory and the Enum. And the Enum could be a Configuration file and you do something like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="java" style="font-family:monospace;">	<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> Base getMeAClass<span style="color: #009900;">&#40;</span><span style="color: #003399;">String</span> className<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
		<span style="color: #666666; font-style: italic;">//Where className could be coming from a configuration file</span>
        <span style="color: #000000; font-weight: bold;">Class</span> clazz <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">Class</span>.<span style="color: #006633;">forName</span><span style="color: #009900;">&#40;</span>className<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #000000; font-weight: bold;">return</span> <span style="color: #009900;">&#40;</span>Base<span style="color: #009900;">&#41;</span> clazz.<span style="color: #006633;">newInstance</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
	<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

This way you don&#8217;t even need the Enum anymore. Just use some configuration to determine what class you need at which point in your implementation without using an If statement at all.

Hope this helps.

I whipped this up from memory so please feel free to tell me if I missed something or have a syntax error in there somewhere&#8230;

As always,
  
Thanks for reading!
  
Gergely.
