---
title: Django – RPG – Part 3
author: hannibal
layout: post
date: 2015-04-21
url: /2015/04/21/django-rpg-part-3/
categories:
  - programming
  - Python
tags:
  - rpg
---
Hello folks.

A small update to this. I created the model now, which is the database design for this app. It&#8217;s very simple, nothing fancy. Also, I&#8217;m writing the app with Python 3 from now on.

Here is the model now:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #ff7700;font-weight:bold;">from</span> django.<span style="color: black;">db</span> <span style="color: #ff7700;font-weight:bold;">import</span> models
<span style="color: #ff7700;font-weight:bold;">from</span> django.<span style="color: black;">contrib</span>.<span style="color: black;">auth</span>.<span style="color: black;">models</span> <span style="color: #ff7700;font-weight:bold;">import</span> User
&nbsp;
<span style="color: #808080; font-style: italic;"># Create your models here.</span>
&nbsp;
&nbsp;
<span style="color: #ff7700;font-weight:bold;">class</span> Item<span style="color: black;">&#40;</span>models.<span style="color: black;">Model</span><span style="color: black;">&#41;</span>:
    name <span style="color: #66cc66;">=</span> models.<span style="color: black;">CharField</span><span style="color: black;">&#40;</span>max_length<span style="color: #66cc66;">=</span><span style="color: #ff4500;">100</span><span style="color: #66cc66;">,</span> default<span style="color: #66cc66;">=</span><span style="color: #483d8b;">"Item"</span><span style="color: black;">&#41;</span>
    damage <span style="color: #66cc66;">=</span> models.<span style="color: black;">IntegerField</span><span style="color: black;">&#40;</span>default<span style="color: #66cc66;">=</span><span style="color: #ff4500;"></span><span style="color: black;">&#41;</span>
    defense <span style="color: #66cc66;">=</span> models.<span style="color: black;">IntegerField</span><span style="color: black;">&#40;</span>default<span style="color: #66cc66;">=</span><span style="color: #ff4500;"></span><span style="color: black;">&#41;</span>
    consumable <span style="color: #66cc66;">=</span> models.<span style="color: black;">BooleanField</span><span style="color: black;">&#40;</span>default<span style="color: #66cc66;">=</span><span style="color: #008000;">False</span><span style="color: black;">&#41;</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">def</span> <span style="color: #0000cd;">__str__</span><span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        <span style="color: #ff7700;font-weight:bold;">return</span> <span style="color: #008000;">self</span>.<span style="color: black;">name</span>
&nbsp;
&nbsp;
<span style="color: #ff7700;font-weight:bold;">class</span> Inventory<span style="color: black;">&#40;</span>models.<span style="color: black;">Model</span><span style="color: black;">&#41;</span>:
    items <span style="color: #66cc66;">=</span> models.<span style="color: black;">ManyToManyField</span><span style="color: black;">&#40;</span>Item<span style="color: black;">&#41;</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">def</span> <span style="color: #0000cd;">__str__</span><span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        <span style="color: #ff7700;font-weight:bold;">return</span> <span style="color: #008000;">self</span>.<span style="color: black;">items</span>
&nbsp;
&nbsp;
<span style="color: #ff7700;font-weight:bold;">class</span> Character<span style="color: black;">&#40;</span>models.<span style="color: black;">Model</span><span style="color: black;">&#41;</span>:
    <span style="color: #808080; font-style: italic;"># By default Django uses the primery key of the related object.</span>
    <span style="color: #808080; font-style: italic;"># Hence, no need to specify User.id.</span>
    <span style="color: #dc143c;">user</span> <span style="color: #66cc66;">=</span> models.<span style="color: black;">OneToOneField</span><span style="color: black;">&#40;</span>User<span style="color: #66cc66;">,</span> null<span style="color: #66cc66;">=</span><span style="color: #008000;">True</span><span style="color: black;">&#41;</span>
    name <span style="color: #66cc66;">=</span> models.<span style="color: black;">CharField</span><span style="color: black;">&#40;</span>max_length<span style="color: #66cc66;">=</span><span style="color: #ff4500;">100</span><span style="color: black;">&#41;</span>
    inventory <span style="color: #66cc66;">=</span> models.<span style="color: black;">ForeignKey</span><span style="color: black;">&#40;</span>Inventory<span style="color: black;">&#41;</span>
&nbsp;
    <span style="color: #ff7700;font-weight:bold;">def</span> <span style="color: #0000cd;">__str__</span><span style="color: black;">&#40;</span><span style="color: #008000;">self</span><span style="color: black;">&#41;</span>:
        <span style="color: #ff7700;font-weight:bold;">return</span> <span style="color: #008000;">self</span>.<span style="color: black;">name</span></pre>
      </td>
    </tr>
  </table>
</div>

Worth noting a few things here. The \_\_str\_\_ is only with Python 3. In Python 2 it would be unicode. And the OneToOne and the foreign key are automatically using Primary keys defined in the references model. The \_\_str\_\_ is there to return some view when you are debugging in the console instead of [<Item: Item object>].

In order to apply this change you just have to run this commend (given you set up your app in the settings.py as an INSTALLED_APP):

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">python manage.py makemigrations polls</pre>
      </td>
    </tr>
  </table>
</div>

This creates the migration script. And this applies it:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="bash" style="font-family:monospace;">python manage.py migrate</pre>
      </td>
    </tr>
  </table>
</div>

I love the fact that django creates incremental migration scripts out of the box. So if there was any problem at all, you can always roll back. Which comes very handy in certain situations.

That&#8217;s it.

Thanks for reading!
  
Gergely.