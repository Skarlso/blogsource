+++
author = "hannibal"
categories = ["programming", "Python"]
date = "2015-04-12"
type = "post"
tags = ["django"]
title = "Django – RPG – Part 2"
url = "/2015/04/12/django-rpg-part-2/"

+++

Hello.

Continuing where we left off with the Django RPG project. Next up is implementing a rudimentary registration and adding the ability to create a character. Maybe even, design the database through django&#8217;s modelling.

<!--more-->

Since we are using Django&#8217;s very own authentication model, I think we are covered in terms of users. Let&#8217;s add two things for now. An Index page, where there is a link to login and a link to registration.

Adding the index first. Later I would like to switch to a base template model, but for now, I created a simple index.html page. That only contains the two links to the two views. The views are a simple function call in the views.py too which the URLConfig will later point to.

For now, the index function looks like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #ff7700;font-weight:bold;">def</span> index<span style="color: black;">&#40;</span>request<span style="color: black;">&#41;</span>:
	title <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"My RPG"</span>
	<span style="color: #ff7700;font-weight:bold;">return</span> render_to_response<span style="color: black;">&#40;</span><span style="color: #483d8b;">'index.html'</span><span style="color: #66cc66;">,</span> <span style="color: black;">&#123;</span><span style="color: #483d8b;">'title'</span>:title<span style="color: black;">&#125;</span><span style="color: black;">&#41;</span>
myrpg/rpg/views.<span style="color: black;">py</span></pre>
      </td>
    </tr>
  </table>
</div>

Note, that the title here is utterly unimportant but because I want to switch to a base.html template I&#8217;ll leave it here for later usage.

That concludes the index. Now, let&#8217;s create the registration. That is a little more complex, but still rather easy. We are just checking of the user already exists or not, if so, display and error, if not, create the user.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #ff7700;font-weight:bold;">def</span> registration<span style="color: black;">&#40;</span>request<span style="color: black;">&#41;</span>:
	state <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"Please register."</span>
	username <span style="color: #66cc66;">=</span> password <span style="color: #66cc66;">=</span> <span style="color: #dc143c;">email</span> <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">''</span>
	<span style="color: #ff7700;font-weight:bold;">if</span> request.<span style="color: black;">POST</span>:
		username <span style="color: #66cc66;">=</span> request.<span style="color: black;">POST</span>.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'username'</span><span style="color: black;">&#41;</span>
		<span style="color: #dc143c;">email</span> <span style="color: #66cc66;">=</span> request.<span style="color: black;">POST</span>.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'email'</span><span style="color: black;">&#41;</span>
		password <span style="color: #66cc66;">=</span> request.<span style="color: black;">POST</span>.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'password'</span><span style="color: black;">&#41;</span>
		<span style="color: #ff7700;font-weight:bold;">if</span> User.<span style="color: black;">objects</span>.<span style="color: #008000;">filter</span><span style="color: black;">&#40;</span>username <span style="color: #66cc66;">=</span> username<span style="color: black;">&#41;</span>.<span style="color: black;">exists</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>:
			<span style="color: #808080; font-style: italic;"># raise forms.ValidationError("Username %s is already in use." % username)</span>
			state <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"Username %s is already in use. Please try another."</span> % username
		<span style="color: #ff7700;font-weight:bold;">else</span>:
			<span style="color: #ff7700;font-weight:bold;">try</span>:
				<span style="color: #dc143c;">user</span> <span style="color: #66cc66;">=</span> User.<span style="color: black;">objects</span>.<span style="color: black;">create_user</span><span style="color: black;">&#40;</span>username <span style="color: #66cc66;">=</span> username<span style="color: #66cc66;">,</span> <span style="color: #dc143c;">email</span> <span style="color: #66cc66;">=</span> <span style="color: #dc143c;">email</span><span style="color: #66cc66;">,</span> password <span style="color: #66cc66;">=</span> password<span style="color: black;">&#41;</span>
				state <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"Thank you for registering with us %s!"</span> % <span style="color: #dc143c;">user</span>.<span style="color: black;">username</span> 
			<span style="color: #ff7700;font-weight:bold;">except</span>:
				state <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"Unexpected error occured: %s"</span> % <span style="color: #dc143c;">sys</span>.<span style="color: black;">exc_info</span><span style="color: black;">&#40;</span><span style="color: black;">&#41;</span><span style="color: black;">&#91;</span><span style="color: #ff4500;"></span><span style="color: black;">&#93;</span>
&nbsp;
	<span style="color: #ff7700;font-weight:bold;">return</span> render_to_response<span style="color: black;">&#40;</span><span style="color: #483d8b;">'registration.html'</span><span style="color: #66cc66;">,</span> <span style="color: black;">&#123;</span><span style="color: #483d8b;">'state'</span>: state<span style="color: black;">&#125;</span><span style="color: #66cc66;">,</span> context_instance <span style="color: #66cc66;">=</span> RequestContext<span style="color: black;">&#40;</span>request<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
myrpg/rpg/views.<span style="color: black;">py</span></pre>
      </td>
    </tr>
  </table>
</div>

Here, I&#8217;m checking to see of the username already exists with the filter. This is by using Django&#8217;s model which models the database like hibernate. It&#8217;s a simple query. And I&#8217;m doing this, because this is faster than raising an exception. Later on, I&#8217;ll be switching to a validation framework and django&#8217;s own auth view. Because, why not.

The URL conf looks like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #ff7700;font-weight:bold;">from</span> django.<span style="color: black;">conf</span>.<span style="color: black;">urls</span> <span style="color: #ff7700;font-weight:bold;">import</span> url
&nbsp;
<span style="color: #ff7700;font-weight:bold;">from</span> . <span style="color: #ff7700;font-weight:bold;">import</span> views
&nbsp;
urlpatterns <span style="color: #66cc66;">=</span> <span style="color: black;">&#91;</span>
    url<span style="color: black;">&#40;</span>r<span style="color: #483d8b;">'^$'</span><span style="color: #66cc66;">,</span> views.<span style="color: black;">index</span><span style="color: #66cc66;">,</span> name<span style="color: #66cc66;">=</span><span style="color: #483d8b;">'index'</span><span style="color: black;">&#41;</span><span style="color: #66cc66;">,</span>
    url<span style="color: black;">&#40;</span>r<span style="color: #483d8b;">'^login/$'</span><span style="color: #66cc66;">,</span> views.<span style="color: black;">login_user</span><span style="color: #66cc66;">,</span> name<span style="color: #66cc66;">=</span><span style="color: #483d8b;">'login'</span><span style="color: black;">&#41;</span><span style="color: #66cc66;">,</span>
    url<span style="color: black;">&#40;</span>r<span style="color: #483d8b;">'^registration/$'</span><span style="color: #66cc66;">,</span> views.<span style="color: black;">registration</span><span style="color: #66cc66;">,</span> name<span style="color: #66cc66;">=</span><span style="color: #483d8b;">'registration'</span><span style="color: black;">&#41;</span><span style="color: #66cc66;">,</span>
<span style="color: black;">&#93;</span>
myrpg/rpg/urls.<span style="color: black;">py</span></pre>
      </td>
    </tr>
  </table>
</div>

And this now, resides in a file under the RPG app and not the main one. The main one includes this one, like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #ff7700;font-weight:bold;">from</span> django.<span style="color: black;">conf</span>.<span style="color: black;">urls</span> <span style="color: #ff7700;font-weight:bold;">import</span> include<span style="color: #66cc66;">,</span> url
<span style="color: #ff7700;font-weight:bold;">from</span> django.<span style="color: black;">contrib</span> <span style="color: #ff7700;font-weight:bold;">import</span> admin
&nbsp;
urlpatterns <span style="color: #66cc66;">=</span> <span style="color: black;">&#91;</span>
    <span style="color: #808080; font-style: italic;"># Examples:</span>
    <span style="color: #808080; font-style: italic;"># url(r'^$', 'myrpg.views.home', name='home'),</span>
    <span style="color: #808080; font-style: italic;"># url(r'^blog/', include('blog.urls')),</span>
&nbsp;
    url<span style="color: black;">&#40;</span>r<span style="color: #483d8b;">'^admin/'</span><span style="color: #66cc66;">,</span> include<span style="color: black;">&#40;</span>admin.<span style="color: #dc143c;">site</span>.<span style="color: black;">urls</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span><span style="color: #66cc66;">,</span>
    url<span style="color: black;">&#40;</span>r<span style="color: #483d8b;">'^rpg/'</span><span style="color: #66cc66;">,</span> include<span style="color: black;">&#40;</span><span style="color: #483d8b;">'rpg.urls'</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span><span style="color: #66cc66;">,</span>
<span style="color: black;">&#93;</span>
myrpg/urls.<span style="color: black;">py</span></pre>
      </td>
    </tr>
  </table>
</div>

That&#8217;s it for now. As always, you can check out the code under github.

Tune in next time, when I&#8217;ll attempt to create a view to create a Character for a logged in user and link it to the user. I&#8217;ll do this with django&#8217;s model framework.
  
Thanks for reading,
  
Gergely.