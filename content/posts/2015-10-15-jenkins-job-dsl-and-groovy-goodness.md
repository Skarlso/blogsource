---
title: Jenkins Job DSL and Groovy goodness
author: hannibal
layout: post
date: 2015-10-15
url: /2015/10/15/jenkins-job-dsl-and-groovy-goodness/
categories:
  - devops
  - groovy
  - knowledge
  - programming
tags:
  - jenkins
---
Hi Folks. 

Ever used <a href="https://wiki.jenkins-ci.org/display/JENKINS/Job+DSL+Plugin" target="_blank">Job DSL plugin</a> for Jenkins? What is that you say? Well, it&#8217;s TEH most awesome plug-in for Jenkins to have, because you can CODE your job configuration and put it under source control. 

Today, however, I&#8217;m not going to write about that because the tutorials on Jenkins JOB DSL are very extensive and very well done. Anyone can pick them up. 

Today, I would like to write about a part of it which is even more interesting. And that is, extracting re-occurring parts in your job configurations.

If you have jobs, which have a common part that is repeated everywhere, you usually have an urge to extracted that into one place, lest it changes and you have to go an apply the change everywhere. That&#8217;s not very efficient. But how do you do that in something which looks like a JSON descriptor?

Fret not, it is just Groovy. And being just groovy, you can use Groovy to implement parts of the job description and then apply that implementation to the job in the DSL. 

Suppose you have an email which you send after every job for which the DSL looks like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="groovy" style="font-family:monospace;">job<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'MyTestJob'</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
    description <span style="color: #ff0000;">'&lt;strong&gt;GENERATED - do not modify&lt;/strong&gt;'</span>
    label<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'machine_label'</span><span style="color: #66cc66;">&#41;</span>
    logRotator<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">30</span>, <span style="color: #66cc66;">-</span><span style="color: #cc66cc;">1</span>, <span style="color: #66cc66;">-</span><span style="color: #cc66cc;">1</span>, <span style="color: #cc66cc;">5</span><span style="color: #66cc66;">&#41;</span>
    parameters <span style="color: #66cc66;">&#123;</span>
        stringParam<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'somestringparam'</span>, <span style="color: #ff0000;">'default_valye'</span>, <span style="color: #ff0000;">'Description'</span><span style="color: #66cc66;">&#41;</span>
    <span style="color: #66cc66;">&#125;</span>
    wrappers <span style="color: #66cc66;">&#123;</span>
        timeout <span style="color: #66cc66;">&#123;</span>
            noActivity<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">600</span><span style="color: #66cc66;">&#41;</span>
            abortBuild<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            failBuild<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            writeDescription<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'Build failed due to timeout after {0} minutes'</span><span style="color: #66cc66;">&#41;</span>
        <span style="color: #66cc66;">&#125;</span>
    <span style="color: #66cc66;">&#125;</span>
    deliveryPipelineConfiguration<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"Main"</span>, <span style="color: #ff0000;">"MyTestJob"</span><span style="color: #66cc66;">&#41;</span>
    wrappers <span style="color: #66cc66;">&#123;</span>
        preBuildCleanup <span style="color: #66cc66;">&#123;</span>
            deleteDirectories<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
        <span style="color: #66cc66;">&#125;</span>
        timestamps<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
    <span style="color: #66cc66;">&#125;</span>
    triggers <span style="color: #66cc66;">&#123;</span>
        cron<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'H 12 * * 1,2'</span><span style="color: #66cc66;">&#41;</span>
    <span style="color: #66cc66;">&#125;</span>
    steps <span style="color: #66cc66;">&#123;</span>
        batchFile<span style="color: #66cc66;">&#40;</span>readFileFromWorkspace<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'relative/path/to/file'</span><span style="color: #66cc66;">&#41;</span><span style="color: #66cc66;">&#41;</span>
    <span style="color: #66cc66;">&#125;</span>
            publishers <span style="color: #66cc66;">&#123;</span>
                wsCleanup<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
                extendedEmail<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'email@address.com'</span>, <span style="color: #ff0000;">'$DEFAULT_SUBJECT'</span>, <span style="color: #ff0000;">'$DEFAULT_CONTENT'</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
                    configure <span style="color: #66cc66;">&#123;</span> node <span style="color: #66cc66;">-&gt;</span>
                        node / presendScript <span style="color: #66cc66;">&lt;&lt;</span> readFileFromWorkspace<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'email_templates/emailtemplate.groovy'</span><span style="color: #66cc66;">&#41;</span>
                        node / replyTo <span style="color: #66cc66;">&lt;&lt;</span> <span style="color: #ff0000;">'$DEFAULT_REPLYTO'</span>
                        node / contentType <span style="color: #66cc66;">&lt;&lt;</span> <span style="color: #ff0000;">'default'</span>
                    <span style="color: #66cc66;">&#125;</span>
                    trigger<span style="color: #66cc66;">&#40;</span>triggerName: <span style="color: #ff0000;">'StillUnstable'</span>, subject: <span style="color: #ff0000;">'$DEFAULT_SUBJECT'</span>, body: <span style="color: #ff0000;">'$DEFAULT_CONTENT'</span>, replyTo: <span style="color: #ff0000;">'$DEFAULT_REPLYTO'</span>, sendToDevelopers: <span style="color: #000000; font-weight: bold;">true</span>, sendToRecipientList: <span style="color: #000000; font-weight: bold;">true</span><span style="color: #66cc66;">&#41;</span>
                    trigger<span style="color: #66cc66;">&#40;</span>triggerName: <span style="color: #ff0000;">'Fixed'</span>, subject: <span style="color: #ff0000;">'$DEFAULT_SUBJECT'</span>, body: <span style="color: #ff0000;">'$DEFAULT_CONTENT'</span>, replyTo: <span style="color: #ff0000;">'$DEFAULT_REPLYTO'</span>, sendToDevelopers: <span style="color: #000000; font-weight: bold;">true</span>, sendToRecipientList: <span style="color: #000000; font-weight: bold;">true</span><span style="color: #66cc66;">&#41;</span>
                    trigger<span style="color: #66cc66;">&#40;</span>triggerName: <span style="color: #ff0000;">'Failure'</span>, subject: <span style="color: #ff0000;">'$DEFAULT_SUBJECT'</span>, body: <span style="color: #ff0000;">'$DEFAULT_CONTENT'</span>, replyTo: <span style="color: #ff0000;">'$DEFAULT_REPLYTO'</span>, sendToDevelopers: <span style="color: #000000; font-weight: bold;">true</span>, sendToRecipientList: <span style="color: #000000; font-weight: bold;">true</span><span style="color: #66cc66;">&#41;</span>
                <span style="color: #66cc66;">&#125;</span>
&nbsp;
            <span style="color: #66cc66;">&#125;</span>
<span style="color: #66cc66;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

Now, that big chunk of email setting is copied into a bunch of files, which is pretty ugly. And once you try to change it, you&#8217;ll have to change it everywhere. Also, the interesting bits here are those readFileFromWorkspace parts. Those allow us to export even larger chunks of the script into external files. Now, because the slave might be located somewhere else, you should not use new File(&#8216;file&#8217;).text in your job DSL. readFileFromWorkspace in the background does that, but applies correct way to the PATH it looks on for the file specified. 

Let&#8217;s put this into a groovy script, shall we? Create a utilities folder where the DSL is and create a groovy file in it like this one:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="groovy" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">package</span> <span style="color: #a1a100;">utilities</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">class</span> JobCommonTemplate <span style="color: #66cc66;">&#123;</span>
    <span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> <span style="color: #993333;">void</span> addEmailTemplate<span style="color: #66cc66;">&#40;</span><span style="color: #000000; font-weight: bold;">def</span> job, <span style="color: #000000; font-weight: bold;">def</span> dslFactory<span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
        <span style="color: #aaaadd; font-weight: bold;">String</span> emailScript <span style="color: #66cc66;">=</span> dslFactory.<span style="color: #006600;">readFileFromWorkspace</span><span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"email_template/EmailTemplate.groovy"</span><span style="color: #66cc66;">&#41;</span>
        job.<span style="color: #006600;">with</span> <span style="color: #66cc66;">&#123;</span>
            publishers <span style="color: #66cc66;">&#123;</span>
                wsCleanup<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
                extendedEmail<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'email@address.com'</span>, <span style="color: #ff0000;">'$DEFAULT_SUBJECT'</span>, <span style="color: #ff0000;">'$DEFAULT_CONTENT'</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
                    configure <span style="color: #66cc66;">&#123;</span> node <span style="color: #66cc66;">-&gt;</span>
                        node / presendScript <span style="color: #66cc66;">&lt;&lt;</span> emailScript
                        node / replyTo <span style="color: #66cc66;">&lt;&lt;</span> <span style="color: #ff0000;">'$DEFAULT_REPLYTO'</span>
                        node / contentType <span style="color: #66cc66;">&lt;&lt;</span> <span style="color: #ff0000;">'default'</span>
                    <span style="color: #66cc66;">&#125;</span>
                    trigger<span style="color: #66cc66;">&#40;</span>triggerName: <span style="color: #ff0000;">'StillUnstable'</span>, subject: <span style="color: #ff0000;">'$DEFAULT_SUBJECT'</span>, body: <span style="color: #ff0000;">'$DEFAULT_CONTENT'</span>, replyTo: <span style="color: #ff0000;">'$DEFAULT_REPLYTO'</span>, sendToDevelopers: <span style="color: #000000; font-weight: bold;">true</span>, sendToRecipientList: <span style="color: #000000; font-weight: bold;">true</span><span style="color: #66cc66;">&#41;</span>
                    trigger<span style="color: #66cc66;">&#40;</span>triggerName: <span style="color: #ff0000;">'Fixed'</span>, subject: <span style="color: #ff0000;">'$DEFAULT_SUBJECT'</span>, body: <span style="color: #ff0000;">'$DEFAULT_CONTENT'</span>, replyTo: <span style="color: #ff0000;">'$DEFAULT_REPLYTO'</span>, sendToDevelopers: <span style="color: #000000; font-weight: bold;">true</span>, sendToRecipientList: <span style="color: #000000; font-weight: bold;">true</span><span style="color: #66cc66;">&#41;</span>
                    trigger<span style="color: #66cc66;">&#40;</span>triggerName: <span style="color: #ff0000;">'Failure'</span>, subject: <span style="color: #ff0000;">'$DEFAULT_SUBJECT'</span>, body: <span style="color: #ff0000;">'$DEFAULT_CONTENT'</span>, replyTo: <span style="color: #ff0000;">'$DEFAULT_REPLYTO'</span>, sendToDevelopers: <span style="color: #000000; font-weight: bold;">true</span>, sendToRecipientList: <span style="color: #000000; font-weight: bold;">true</span><span style="color: #66cc66;">&#41;</span>
                <span style="color: #66cc66;">&#125;</span>
&nbsp;
            <span style="color: #66cc66;">&#125;</span>
        <span style="color: #66cc66;">&#125;</span>
    <span style="color: #66cc66;">&#125;</span>
<span style="color: #66cc66;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

The function addEmailTemplate gets two parameters. A job, which is an implementation of a Job, and a dslFactory which is a DslFactory. That factory is an interface which defines our readFileFromWorkspace. Where do we get the implementation from then? That will be from the Job. Let&#8217;s alter our job to apply this Groovy script.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="groovy" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">import</span> <span style="color: #a1a100;">utilities.JobCommonTemplate</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">def</span> myJob <span style="color: #66cc66;">=</span> job<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'MyTestJob'</span><span style="color: #66cc66;">&#41;</span> <span style="color: #66cc66;">&#123;</span>
    description <span style="color: #ff0000;">'&lt;strong&gt;GENERATED - do not modify&lt;/strong&gt;'</span>
    label<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'machine_label'</span><span style="color: #66cc66;">&#41;</span>
    logRotator<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">30</span>, <span style="color: #66cc66;">-</span><span style="color: #cc66cc;">1</span>, <span style="color: #66cc66;">-</span><span style="color: #cc66cc;">1</span>, <span style="color: #cc66cc;">5</span><span style="color: #66cc66;">&#41;</span>
    parameters <span style="color: #66cc66;">&#123;</span>
        stringParam<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'somestringparam'</span>, <span style="color: #ff0000;">'default_valye'</span>, <span style="color: #ff0000;">'Description'</span><span style="color: #66cc66;">&#41;</span>
    <span style="color: #66cc66;">&#125;</span>
    wrappers <span style="color: #66cc66;">&#123;</span>
        timeout <span style="color: #66cc66;">&#123;</span>
            noActivity<span style="color: #66cc66;">&#40;</span><span style="color: #cc66cc;">600</span><span style="color: #66cc66;">&#41;</span>
            abortBuild<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            failBuild<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
            writeDescription<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'Build failed due to timeout after {0} minutes'</span><span style="color: #66cc66;">&#41;</span>
        <span style="color: #66cc66;">&#125;</span>
    <span style="color: #66cc66;">&#125;</span>
    deliveryPipelineConfiguration<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">"Main"</span>, <span style="color: #ff0000;">"MyTestJob"</span><span style="color: #66cc66;">&#41;</span>
    wrappers <span style="color: #66cc66;">&#123;</span>
        preBuildCleanup <span style="color: #66cc66;">&#123;</span>
            deleteDirectories<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
        <span style="color: #66cc66;">&#125;</span>
        timestamps<span style="color: #66cc66;">&#40;</span><span style="color: #66cc66;">&#41;</span>
    <span style="color: #66cc66;">&#125;</span>
    triggers <span style="color: #66cc66;">&#123;</span>
        cron<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'H 12 * * 1,2'</span><span style="color: #66cc66;">&#41;</span>
    <span style="color: #66cc66;">&#125;</span>
    steps <span style="color: #66cc66;">&#123;</span>
        batchFile<span style="color: #66cc66;">&#40;</span>readFileFromWorkspace<span style="color: #66cc66;">&#40;</span><span style="color: #ff0000;">'relative/path/to/file'</span><span style="color: #66cc66;">&#41;</span><span style="color: #66cc66;">&#41;</span>
    <span style="color: #66cc66;">&#125;</span>
<span style="color: #66cc66;">&#125;</span>
&nbsp;
JobCommonTemplate.<span style="color: #006600;">addEmailTemplate</span><span style="color: #66cc66;">&#40;</span>myJob, <span style="color: #000000; font-weight: bold;">this</span><span style="color: #66cc66;">&#41;</span></pre>
      </td>
    </tr>
  </table>
</div>

Notice three things here.

#1 => **import**. We import the script from utilities folder which we created and placed the script into it.
  
#2 => **def myJob**. We create a variable which will contain our job&#8217;s description.
  
#3 => **this**. &#8216;this&#8217; will be the DslFactory. That&#8217;s where we get our readFileFromWorkspace implementation. 

And that&#8217;s it. We have extracted a part of our job which is re-occurring and we found our implementation for our readFileFromWorkspace. DslFactory has most of the things which you need in a job description, would you want to expand on this and extract other bits and pieces. 

Have fun, and happy coding!
  
As always,
  
Thanks for reading!
  
Gergely.