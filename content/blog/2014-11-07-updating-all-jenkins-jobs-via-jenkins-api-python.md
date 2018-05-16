+++
author = "hannibal"
categories = ["Python"]
date = "2014-11-07"
type = "post"
tags = ["jenkins"]
title = "Updating All Jenkins Jobs Via Jenkins API – Python"
url = "/2014/11/07/updating-all-jenkins-jobs-via-jenkins-api-python/"

+++

Hello everybody.

I would like to share with you a small script I wrote to update all, or a single, Jenkins job from a Python script remotely.

<!--more-->

This will enable you to update a Jenkins job from anywhere using an admin credential based on a config.xml template that you have. With this, if you want to apply a config change to all or just a single job in Jenkins, you don&#8217;t have to go and do it for all the rest. You just call this script and it will cycle through all the jobs you have and update them if the begin with &#8220;yourpipelinedelimiter&#8221; or if they aren&#8217;t in a restricted list of jobs. The delimiter helps to identify pipelines which are dev pipelines. If you have multiple pipelines which are helpers or builders and you don&#8217;t usually apply the same config to them, than the delimiter can help identify the dev pipelines you actually want to update.

Enjoy, hope it helps someone.

And now, without any further ado:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="python" style="font-family:monospace;"><span style="color: #483d8b;">'''
	Created to update multiple pipelines in jenkins with a given configuration and job list.
	Usage: 
	Example 1:
	Updating a single pipeline's job with a given config.xml.
	python update-jenkins-jobs.py job-name config.xml pipeline-name
	Example 2:
	Updating every pipeline in jenkins dynamically. !!!WARNING!!! This updates every job EXCEPT of the ones specified in restricted_jobs.
	python update-jenkins-jobs.py job-name config.xml
'''</span>
<span style="color: #ff7700;font-weight:bold;">from</span> <span style="color: #dc143c;">xml</span>.<span style="color: black;">dom</span> <span style="color: #ff7700;font-weight:bold;">import</span> minidom
<span style="color: #ff7700;font-weight:bold;">import</span> requests
<span style="color: #ff7700;font-weight:bold;">import</span> <span style="color: #dc143c;">sys</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">def</span> update_pipeline<span style="color: black;">&#40;</span>pipeline<span style="color: black;">&#41;</span>:
	<span style="color: #483d8b;">'''
	Takes in a list of pipelines to update.
	'''</span>
	config_file <span style="color: #66cc66;">=</span> <span style="color: #008000;">open</span><span style="color: black;">&#40;</span>config_to_use<span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'rb'</span><span style="color: black;">&#41;</span>
	headers <span style="color: #66cc66;">=</span> <span style="color: black;">&#123;</span><span style="color: #483d8b;">'content-type'</span>: <span style="color: #483d8b;">'application/xml'</span><span style="color: black;">&#125;</span>
	<span style="color: #ff7700;font-weight:bold;">print</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"Updating pipelines: "</span><span style="color: #66cc66;">,</span> pipeline<span style="color: black;">&#41;</span>
&nbsp;
	<span style="color: #ff7700;font-weight:bold;">for</span> dev_job <span style="color: #ff7700;font-weight:bold;">in</span> pipeline:
		url <span style="color: #66cc66;">=</span> <span style="color: #483d8b;">"http://jenkins:9999/job/%s/job/%s/config.xml"</span> % <span style="color: black;">&#40;</span>dev_job<span style="color: #66cc66;">,</span> job_to_update<span style="color: black;">&#41;</span>
		r <span style="color: #66cc66;">=</span> requests.<span style="color: black;">post</span><span style="color: black;">&#40;</span>url<span style="color: #66cc66;">,</span> data<span style="color: #66cc66;">=</span>config_file<span style="color: #66cc66;">,</span> headers<span style="color: #66cc66;">=</span>headers<span style="color: #66cc66;">,</span> auth<span style="color: #66cc66;">=</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'user'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'password'</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
		<span style="color: #ff7700;font-weight:bold;">print</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"Updating pipeline: %s; Response Code: %s"</span> % <span style="color: black;">&#40;</span>dev_job<span style="color: #66cc66;">,</span> r<span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
&nbsp;
&nbsp;
<span style="color: #ff7700;font-weight:bold;">def</span> get_dev_pipelines<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span>:
	<span style="color: #483d8b;">'''
	Gets a list of pipelines which can be used by update_pipeline.
	'''</span>
	r <span style="color: #66cc66;">=</span> requests.<span style="color: black;">get</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'http://jenkins:9999/api/xml'</span><span style="color: #66cc66;">,</span> auth<span style="color: #66cc66;">=</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'user'</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">'password'</span><span style="color: black;">&#41;</span><span style="color: #66cc66;">,</span> stream<span style="color: #66cc66;">=</span><span style="color: #008000;">True</span><span style="color: black;">&#41;</span>
	job_list_xml <span style="color: #66cc66;">=</span> r.<span style="color: black;">text</span>
&nbsp;
	xmldoc <span style="color: #66cc66;">=</span> minidom.<span style="color: black;">parseString</span><span style="color: black;">&#40;</span>job_list_xml<span style="color: black;">&#41;</span>
	itemlist <span style="color: #66cc66;">=</span> xmldoc.<span style="color: black;">getElementsByTagName</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">'name'</span><span style="color: black;">&#41;</span> 
&nbsp;
	dev_job_list <span style="color: #66cc66;">=</span> <span style="color: black;">&#91;</span><span style="color: black;">&#93;</span>
&nbsp;
	restricted_jobs <span style="color: #66cc66;">=</span> <span style="color: black;">&#91;</span><span style="color: #483d8b;">"yourpipelinedelimiter-dev-pipeline1"</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">"yourpipelinedelimiter-dev-pipeline2"</span><span style="color: #66cc66;">,</span> <span style="color: #483d8b;">"yourpipelinedelimiter-dev-pipeline3"</span><span style="color: black;">&#93;</span>
	<span style="color: #ff7700;font-weight:bold;">for</span> s <span style="color: #ff7700;font-weight:bold;">in</span> itemlist:
	    <span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: black;">&#40;</span><span style="color: #483d8b;">"yourpipelinedelimiter-dev"</span> <span style="color: #ff7700;font-weight:bold;">in</span> s.<span style="color: black;">firstChild</span>.<span style="color: black;">nodeValue</span><span style="color: black;">&#41;</span> :
	    	value <span style="color: #66cc66;">=</span> s.<span style="color: black;">firstChild</span>.<span style="color: black;">nodeValue</span>
	    	<span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: black;">&#40;</span>value <span style="color: #ff7700;font-weight:bold;">not</span> <span style="color: #ff7700;font-weight:bold;">in</span> restricted_jobs<span style="color: black;">&#41;</span>:
	    		dev_job_list.<span style="color: black;">append</span><span style="color: black;">&#40;</span>value<span style="color: black;">&#41;</span>
&nbsp;
	<span style="color: #ff7700;font-weight:bold;">return</span> dev_job_list
&nbsp;
&nbsp;
job_to_update <span style="color: #66cc66;">=</span> <span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#91;</span><span style="color: #ff4500;">1</span><span style="color: black;">&#93;</span>
config_to_use <span style="color: #66cc66;">=</span> <span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#91;</span><span style="color: #ff4500;">2</span><span style="color: black;">&#93;</span>
dev_pipeline <span style="color: #66cc66;">=</span> <span style="color: black;">&#91;</span><span style="color: black;">&#93;</span>
&nbsp;
<span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: #008000;">len</span><span style="color: black;">&#40;</span><span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#41;</span> &gt<span style="color: #66cc66;">;</span> <span style="color: #ff4500;">3</span>:
	<span style="color: #ff7700;font-weight:bold;">print</span><span style="color: black;">&#40;</span><span style="color: #483d8b;">"Args length:"</span><span style="color: #66cc66;">,</span> <span style="color: #008000;">len</span><span style="color: black;">&#40;</span><span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#41;</span><span style="color: black;">&#41;</span>
	dev_pipeline.<span style="color: black;">append</span><span style="color: black;">&#40;</span><span style="color: #dc143c;">sys</span>.<span style="color: black;">argv</span><span style="color: black;">&#91;</span><span style="color: #ff4500;">3</span><span style="color: black;">&#93;</span><span style="color: black;">&#41;</span>
&nbsp;
update_pipeline<span style="color: black;">&#40;</span>get_dev_pipelines<span style="color: black;">&#40;</span><span style="color: black;">&#41;</span> <span style="color: #ff7700;font-weight:bold;">if</span> <span style="color: #ff7700;font-weight:bold;">not</span> dev_pipeline <span style="color: #ff7700;font-weight:bold;">else</span> dev_pipeline<span style="color: black;">&#41;</span></pre>
      </td>
    </tr>
  </table>
</div>

Thanks for reading.
  
Gergely.