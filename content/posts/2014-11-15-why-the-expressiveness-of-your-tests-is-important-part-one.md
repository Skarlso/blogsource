---
title: Why the expressiveness of your Tests is important – Part One
author: hannibal
layout: post
date: 2014-11-15
url: /2014/11/15/why-the-expressiveness-of-your-tests-is-important-part-one/
categories:
  - groovy
  - programming
  - testing
---
Hello Everybody.

This time I&#8217;d like to write about the expressiveness of a Test. I think that it&#8217;s very important to write understandable and expressive tests. In older times I was studying novel writing. There is a rule which a novel needs to follow. It goes something like this: &#8220;A novel needs to lead its reader and make him understand in the simplest way what&#8217;s going on, with whom and why?&#8221;. In other words, it&#8217;s not a puzzle. It should be obvious what the test is trying to do and it should not require the reader to try and solve it in order to understand it.

<!--more-->

I&#8217;m planning this as a series since there are multiple problems with a test I can talk about here.

**Geb Tests**

Example:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="groovy" style="font-family:monospace;">    <span style="color: #000000; font-weight: bold;">def</span> <span style="color: #ff0000;">"login to the home page"</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
        given: <span style="color: #ff0000;">"I am at homepages"</span>
            go <span style="color: #ff0000;">"http://localhost:8080/home"</span>
            at HomePage
&nbsp;
        when: <span style="color: #ff0000;">"I entir my credential"</span>
            filloutLoginForm<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"username"</span>, <span style="color: #ff0000;">"password"</span><span style="color: #66cc66;">&#41;</span>
            at MyAccountPage
&nbsp;
        then: <span style="color: #ff0000;">"I can accass my wallet"</span>
            openWallet<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            waitFor <span style="color: #66cc66;">&#123;</span> <span style="color: #CC0099;">contains</span><span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"Balance"</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#125;</span>
    <span style="color: #66cc66;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Now, read this test. It doesn&#8217;t really make any sense at the first read, right? You need to actually think what is going on there. Of course if you read it slow enough you&#8217;ll get what it&#8217;s trying to do. But you don&#8217;t know what fillform does. Apparently it also submits the form because after fillform you are suddenly at MyAccountPage.

There are several things wrong with this one, let&#8217;s start with the pageobject.

**PageObjects**

At and toAt return page objects. We can use that to actually make the calling explicit and make it more readable and identify where a function comes from.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="groovy" style="font-family:monospace;">    <span style="color: #000000; font-weight: bold;">def</span> <span style="color: #ff0000;">"login to the home page"</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
        given: <span style="color: #ff0000;">"I am at homepages"</span>
            go <span style="color: #ff0000;">"http://localhost:8080/home"</span>
            HomePage homePage <span style="color: #66cc66;">=</span> at HomePage
&nbsp;
        when: <span style="color: #ff0000;">"I entir my credential"</span>
            homePage.<span style="color: #006600;">filloutLoginForm</span><span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"username"</span>, <span style="color: #ff0000;">"password"</span><span style="color: #66cc66;">&#41;</span>
            MyAccountPage myAccountPage <span style="color: #66cc66;">=</span> at MyAccountPage
&nbsp;
        then: <span style="color: #ff0000;">"I can accass my wallet"</span>
            myAccountPage.<span style="color: #006600;">openWallet</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            waitFor <span style="color: #66cc66;">&#123;</span> <span style="color: #CC0099;">contains</span><span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"Balance"</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#125;</span>
    <span style="color: #66cc66;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

This reads much better now. You know where the function is coming from and your IDE will not go nuts from things it can&#8217;t find. And you have autocompletion so there is no fear that you simply mistype something.

**Side effects**

Next step, let&#8217;s remove some of the side effects.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="groovy" style="font-family:monospace;">    <span style="color: #000000; font-weight: bold;">def</span> <span style="color: #ff0000;">"login to the home page"</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
        given: <span style="color: #ff0000;">"I am at homepages"</span>
            go <span style="color: #ff0000;">"http://localhost:8080/home"</span>
            HomePage homePage <span style="color: #66cc66;">=</span> at HomePage
&nbsp;
        when: <span style="color: #ff0000;">"I entir my credential"</span>
            homePage.<span style="color: #006600;">filloutLoginForm</span><span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"username"</span>, <span style="color: #ff0000;">"password"</span><span style="color: #66cc66;">&#41;</span>
            homePage.<span style="color: #006600;">submitLoginForm</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            MyAccountPage myAccountPage <span style="color: #66cc66;">=</span> at MyAccountPage
&nbsp;
        then: <span style="color: #ff0000;">"I can accass my wallet"</span>
            myAccountPage.<span style="color: #006600;">openWallet</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            waitFor <span style="color: #66cc66;">&#123;</span> myAccountPage.<span style="color: #006600;">accountIsDisplayed</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#125;</span>
    <span style="color: #66cc66;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Now this is again much better. There are no steps left out. And you can test now the FillForm and the submit independently. Like, submitting the form without filling it out! Or filling it out and not submiting it. Reads better, is explicit, more easy to understand.

And the last one for today:

**Grammar**

I wonder if you noticed it&#8230; The grammar is a little bit off in the tests. A small mistake here and there. You might think that, who cares? That&#8217;s a very bad thought. I think the correct grammar reflects caring. It reflects that we thought about this test and that we thought about the quality of it. Because it means that after you wrote it, you actually re-read the test to make sure it&#8217;s understandable and readable.

So let us correct that:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="groovy" style="font-family:monospace;">    <span style="color: #000000; font-weight: bold;">def</span> <span style="color: #ff0000;">"As a player I can log in to check my account."</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
        given: <span style="color: #ff0000;">"I am at the homepage"</span>
            go <span style="color: #ff0000;">"http://localhost:8080/home"</span>
            HomePage homePage <span style="color: #66cc66;">=</span> at HomePage
&nbsp;
        when: <span style="color: #ff0000;">"I enter my log in credentials."</span>
            homePage.<span style="color: #006600;">filloutLoginForm</span><span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"username"</span>, <span style="color: #ff0000;">"password"</span><span style="color: #66cc66;">&#41;</span>
            homePage.<span style="color: #006600;">submitLoginForm</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            MyAccountPage myAccountPage <span style="color: #66cc66;">=</span> at MyAccountPage
&nbsp;
        then: <span style="color: #ff0000;">"I'm directed to my account page."</span>
            myAccountPage.<span style="color: #006600;">openWallet</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            waitFor <span style="color: #66cc66;">&#123;</span> myAccountPage.<span style="color: #006600;">accountIsDisplayed</span><span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#125;</span>
    <span style="color: #66cc66;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

I also took the liberty of re-phrasing some of the text so that it shows what the test is about and what the user really would like to achieve here. Now try reading that last one. Does it make more sense? Did you understand it at first go? Did it read like a good story?

There is a coding practice which goes something like this: &#8220;Good code is code which doesn&#8217;t surprise you as you read it.&#8221; Which means the exact thing happens which you thought of would happen. I think that applies to tests as well. The steps of the test shouldn&#8217;t come to you as a surprise. Especially if you know what the application is supposed to do.

So that&#8217;s all for today folks. Thank you for reading! If you have a nasty test which you would like me to dissect and make it better and human readable, please share it in the comment section and I will do my best to come up with a good solution for it.

And as always,
  
Have a nice day!
  
Gergely.