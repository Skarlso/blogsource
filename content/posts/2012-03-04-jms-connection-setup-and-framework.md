---
title: JMS Connection setup and Framework
author: hannibal
layout: post
date: 2012-03-04
url: /2012/03/04/jms-connection-setup-and-framework/
categories:
  - java
  - knowledge
  - problem solving
  - programming
  - testing
tags:
  - factory
  - java
  - pattern
  - service
---
Hello chumps. 

Today I want to write about jms connection testing with a small framework. I wrote a small thing using a factory object model. It&#8217;s a lead, a proof of concept. You can use this to go onward. 

First, let&#8217;s begin with the JMS connection it self. 

**JMS Connection**

First rule of thumb is: &#8220;Don&#8217;t wait for a response when dealing with JMS queues.&#8221; How so? Because, a JMS queue is asynchronous so you wont get back anything. There are however two ways of checking if it was a success or not. 

1: Check your database. The service you are trying out probably records something in the database, right? Check it&#8230; You can use a simple JDBC connection, or a Postgres connection or whatever your choice of database is. 

2: You can monitor use the log of your choice of service provider. If there is an exception the moment you send something, you can be sure it is received. Just the format is not correct. This is of course based on how your service handles exceptions.

So let&#8217;s get down to business. 

First, there is a really good article on how to create a JMS connection. 

This is the link for it: [Simple Guide to Java message service JMS using ActiveMQ][1]

Itt will tell you everything you need to know about creating a connection and waiting for a response. 

I will tell you now how to use this information in a real live environment. 

In a real environment you will be using a queue which has certain settings that will not allow you to &#8220;join&#8221; it, or creating it. And you need to get the name of the queue and certain settings, like the destination URL. 

First, the tool you are going to use is called JConsole. JConsole is a tool to monitor applications. It&#8217;s tool to monitor the JVM. I wont go into details about it since there are numerous descriptions about it. It is part of the java installation. 

So after firing it up and giving it a connection url which would look like this: &#8216;service:jmx:rmi:///jndi/rmi://hostName:portNum/jmxrmi&#8217;, you would go ahead and search on the TAB:**Threads**.

Look for a Thread that is labelled like this: <YourConnectionLayer> Transport Server: tcp://0.0.0.0: <port> 

This will be your destination url. 

In the blog the guy is using ActiveMQ. It&#8217;s your best guess. It&#8217;s lightweight, it&#8217;s fast it&#8217;s easy. Go for it. 

So your Destination would look like this:

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
        <pre class="java" style="font-family:monospace;">    ConnectionFactory connectionFactory <span style="color: #339933;">=</span>
            <span style="color: #000000; font-weight: bold;">new</span> ActiveMQConnectionFactory<span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"&lt;yourserviceparameter&gt;://tcp://0.0.0.0:&lt;port&gt;"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #003399;">Connection</span> connection <span style="color: #339933;">=</span> connectionFactory.<span style="color: #006633;">createConnection</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    connection.<span style="color: #006633;">start</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
      </td>
    </tr>
  </table>
</div>

After that you will need the queue name which you can get as easy as this. Go to the TAB **MBeans**. There you can see, if you are using ActiveMQ, you will see something like this : org.active.activemq. Open this up and you will see under localhost a number of queues that your server has configured. Open up one of them and copy the queue name in the createQueue. 

Use it like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;">    Destination destination <span style="color: #339933;">=</span> session.<span style="color: #006633;">createQueue</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"&lt;queue name&gt;"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
      </td>
    </tr>
  </table>
</div>

Of course if your service is configured properly you wont have any access to it. Use the connection like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="line_numbers">
        <pre>1
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;">    connection <span style="color: #339933;">=</span> connectionFactory.<span style="color: #006633;">createConnection</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"username"</span>, <span style="color: #0000ff;">"password"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
      </td>
    </tr>
  </table>
</div>

You will have now logged in with the proper user.

Now you can send the message. You have everything configured.

**Framework**

Let&#8217;s speak about the framework you will need to properly use this technology.

One of the paradigms for programming is design to interfaces. If you need a proper working framework, your ave to design with the mind set to changing pieces of code. Thinking about what would change the most. Your connection settings. You want a framework which can use any kind of connection. Not just JMS but whatever connection you would like. It could be a synchronous one. Or a database one. Or a JMS. Doesn&#8217;t matter. You are only interested in a message sent or a connection, or whatever you want. 

So let&#8217;s get to it. 

Interface:

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
        <pre class="java" style="font-family:monospace;">    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">interface</span> IConnection <span style="color: #009900;">&#123;</span>
	<span style="color: #000066; font-weight: bold;">void</span> sendMessage<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

This is sample connection interface. You could have numerous templates here.

You will be using an object factory pattern here. Your implementer will be taken for a Java Property file. But it can be taken from whatever configuration you like. XML maybe, or a database even. 

Let&#8217;s see you connection factory:

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
        <pre class="java" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">class</span> ConnFactory <span style="color: #009900;">&#123;</span>
&nbsp;
	<span style="color: #000000; font-weight: bold;">static</span> Logger logger <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> Logger<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
	<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> IConnection getImplementer<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>
	<span style="color: #009900;">&#123;</span>
		<span style="color: #003399;">Properties</span> prop <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> <span style="color: #003399;">Properties</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">try</span>
		<span style="color: #009900;">&#123;</span>
			prop.<span style="color: #006633;">load</span><span style="color: #009900;">&#40;</span><span style="color: #000000; font-weight: bold;">new</span> <span style="color: #003399;">FileInputStream</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"conf/implementer.property"</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
		<span style="color: #000000; font-weight: bold;">catch</span> <span style="color: #009900;">&#40;</span><span style="color: #003399;">IOException</span> io<span style="color: #009900;">&#41;</span>
		<span style="color: #009900;">&#123;</span>
			logger.<span style="color: #006633;">Log</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"Could not find property file: "</span> <span style="color: #339933;">+</span> io.<span style="color: #006633;">getMessage</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
&nbsp;
		<span style="color: #003399;">String</span> implementerClass <span style="color: #339933;">=</span> prop.<span style="color: #006633;">getProperty</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"implementer"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
		Class<span style="color: #339933;">&lt;?&gt;</span> iConnect <span style="color: #339933;">=</span> <span style="color: #000066; font-weight: bold;">null</span><span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">try</span>
		<span style="color: #009900;">&#123;</span>
			iConnect <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">Class</span>.<span style="color: #006633;">forName</span><span style="color: #009900;">&#40;</span>implementerClass<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
		<span style="color: #000000; font-weight: bold;">catch</span> <span style="color: #009900;">&#40;</span><span style="color: #003399;">ClassNotFoundException</span> ce<span style="color: #009900;">&#41;</span>
		<span style="color: #009900;">&#123;</span>
			logger.<span style="color: #006633;">Log</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"Class could not be found: "</span> <span style="color: #339933;">+</span> ce.<span style="color: #006633;">getMessage</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
&nbsp;
		IConnection connection <span style="color: #339933;">=</span> <span style="color: #000066; font-weight: bold;">null</span><span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">try</span>
		<span style="color: #009900;">&#123;</span>
			connection <span style="color: #339933;">=</span> <span style="color: #009900;">&#40;</span>IConnection<span style="color: #009900;">&#41;</span> iConnect.<span style="color: #006633;">newInstance</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
		<span style="color: #000000; font-weight: bold;">catch</span> <span style="color: #009900;">&#40;</span><span style="color: #003399;">IllegalAccessException</span> ie<span style="color: #009900;">&#41;</span>
		<span style="color: #009900;">&#123;</span>
			logger.<span style="color: #006633;">Log</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"Illegal access excpetion: "</span> <span style="color: #339933;">+</span> ie.<span style="color: #006633;">getMessage</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #009900;">&#125;</span> <span style="color: #000000; font-weight: bold;">catch</span> <span style="color: #009900;">&#40;</span><span style="color: #003399;">InstantiationException</span> e<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
&nbsp;
			logger.<span style="color: #006633;">Log</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"Instatiation exception occured. "</span> <span style="color: #339933;">+</span> e.<span style="color: #006633;">getMessage</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
&nbsp;
		<span style="color: #000000; font-weight: bold;">return</span> connection<span style="color: #339933;">;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Easy enough, right? Class.forname will instantiate the class name you have in the property file. This could be something like this: com.packagename.ClassName. Doesn&#8217;t matter to you. You can add some typeof checks, or instanceof checks, whatever you like. Or you can use <Type> generics. 

Let&#8217;s get to the concrete implementation:

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
</pre>
      </td>
      
      <td class="code">
        <pre class="java" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">class</span> JMSConnectionImpl <span style="color: #000000; font-weight: bold;">implements</span> IConnection <span style="color: #009900;">&#123;</span>
    Logger logger <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> Logger<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000066; font-weight: bold;">void</span> sendMessage<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>
    <span style="color: #009900;">&#123;</span>
&nbsp;
   	<span style="color: #003399;">Connection</span> connection <span style="color: #339933;">=</span> <span style="color: #000066; font-weight: bold;">null</span><span style="color: #339933;">;</span>
        .
        .
        .
        <span style="color: #000000; font-weight: bold;">finally</span>
        <span style="color: #009900;">&#123;</span>
            connection.<span style="color: #006633;">close</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span>
&nbsp;
    <span style="color: #009900;">&#125;</span>
<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Simple enough. Here you have a concrete implementation of your collection and your sender class.

And the simple usage facility of this is&#8230; simple too:

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
        <pre class="java" style="font-family:monospace;">    IConnection iConnection <span style="color: #339933;">=</span> ConnFactory.<span style="color: #006633;">getImplementer</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    iConnection.<span style="color: #006633;">sendMessage</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
      </td>
    </tr>
  </table>
</div>

Simple enough too, right? So what happens here? You have a factory that will give you back any kind of implementation you are writing in you property file. You don&#8217;t care what the implementation is in your test. You don&#8217;t care what it&#8217;s name is. You don&#8217;t care what it&#8217;s result is. Okay, you care about the result, but that&#8217;s another history since you will check that elsewhere. 

There you go. If any question occurs, please don&#8217;t hesitate to ask. 

Thanks for reading!

 [1]: http://www.javablogging.com/simple-guide-to-java-message-service-jms-using-activemq "Simple JMS How To"