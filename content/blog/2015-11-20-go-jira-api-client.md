+++
author = "hannibal"
categories = ["Go", "programming"]
date = "2015-11-20"
type = "post"
title = "Go JIRA API client"
url = "/2015/11/20/go-jira-api-client/"

+++

Hi folks.

So, I was playing around and created a client for JIRA written in Go. It was nice to do some JSON transformation. And sending POSTS was really trivial. 

It&#8217;s still in it&#8217;s infancy and I have a couple of more features I want to implement, but, here is the code&#8230;

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="go" style="font-family:monospace;"><span style="color: #b1b100; font-weight: bold;">package</span> main
&nbsp;
<span style="color: #b1b100; font-weight: bold;">import</span> <span style="color: #339933;">(</span>
	<span style="color: #cc66cc;">"bytes"</span>
	<span style="color: #cc66cc;">"encoding/json"</span>
	<span style="color: #cc66cc;">"flag"</span>
	<span style="color: #cc66cc;">"fmt"</span>
	<span style="color: #cc66cc;">"io/ioutil"</span>
	<span style="color: #cc66cc;">"log"</span>
	<span style="color: #cc66cc;">"net/http"</span>
	<span style="color: #cc66cc;">"os"</span>
&nbsp;
	<span style="color: #cc66cc;">"github.com/BurntSushi/toml"</span>
<span style="color: #339933;">)</span>
&nbsp;
<span style="color: #b1b100; font-weight: bold;">var</span> configFile <span style="color: #339933;">=</span> <span style="color: #cc66cc;">"~/.jira_config.toml"</span>
<span style="color: #b1b100; font-weight: bold;">var</span> parameter <span style="color: #993333;">string</span>
&nbsp;
<span style="color: #b1b100; font-weight: bold;">var</span> flags <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
	Comment     <span style="color: #993333;">string</span>
	Description <span style="color: #993333;">string</span>
	IssueKey    <span style="color: #993333;">string</span>
	Priority    <span style="color: #993333;">string</span>
	Resolution  <span style="color: #993333;">string</span>
	Title       <span style="color: #993333;">string</span>
	Project     <span style="color: #993333;">string</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//Issue is a representation of a Jira Issue</span>
<span style="color: #b1b100; font-weight: bold;">type</span> Issue <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
	Fields <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
		Project <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
			Key <span style="color: #993333;">string</span> <span style="color: #0000ff;">`json:"key"`</span>
		<span style="color: #339933;">}</span> <span style="color: #0000ff;">`json:"project"`</span>
		Summary     <span style="color: #993333;">string</span> <span style="color: #0000ff;">`json:"summary"`</span>
		Description <span style="color: #993333;">string</span> <span style="color: #0000ff;">`json:"description"`</span>
		Issuetype   <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
			Name <span style="color: #993333;">string</span> <span style="color: #0000ff;">`json:"name"`</span>
		<span style="color: #339933;">}</span> <span style="color: #0000ff;">`json:"issuetype"`</span>
		Priority <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
			ID <span style="color: #993333;">string</span> <span style="color: #0000ff;">`json:"id"`</span>
		<span style="color: #339933;">}</span> <span style="color: #0000ff;">`json:"priority"`</span>
	<span style="color: #339933;">}</span> <span style="color: #0000ff;">`json:"fields"`</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//Transition defines a transition json object. Used for starting, stoppinp</span>
<span style="color: #666666; font-style: italic;">//generally for state stranfer</span>
<span style="color: #b1b100; font-weight: bold;">type</span> Transition <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
	Fields <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
		Resolution <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
			Name <span style="color: #993333;">string</span> <span style="color: #0000ff;">`json:"name"`</span>
		<span style="color: #339933;">}</span> <span style="color: #0000ff;">`json:"resolution"`</span>
	<span style="color: #339933;">}</span> <span style="color: #0000ff;">`json:"fields"`</span>
	Transition <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
		ID <span style="color: #993333;">string</span> <span style="color: #0000ff;">`json:"id"`</span>
	<span style="color: #339933;">}</span> <span style="color: #0000ff;">`json:"transition"`</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #666666; font-style: italic;">//Credentials a representation of a JIRA config which helds API permissions</span>
<span style="color: #b1b100; font-weight: bold;">type</span> Credentials <span style="color: #993333;">struct</span> <span style="color: #339933;">{</span>
	Username <span style="color: #993333;">string</span>
	Password <span style="color: #993333;">string</span>
	URL      <span style="color: #993333;">string</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> init<span style="color: #339933;">()</span> <span style="color: #339933;">{</span>
	flag<span style="color: #339933;">.</span>StringVar<span style="color: #339933;">(</span>&flags<span style="color: #339933;">.</span>Comment<span style="color: #339933;">,</span> <span style="color: #cc66cc;">"m"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"Default Comment"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"A Comment when changing the status of an Issue."</span><span style="color: #339933;">)</span>
	flag<span style="color: #339933;">.</span><span style="">StringVar</span><span style="color: #339933;">(</span><span style="color: #339933;">&</span>flags<span style="color: #339933;">.</span><span style="">Description</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"d"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"Default Description"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"Provide a description for a newly created Issue."</span><span style="color: #339933;">)</span>
	flag<span style="color: #339933;">.</span><span style="">StringVar</span><span style="color: #339933;">(</span><span style="color: #339933;">&</span>flags<span style="color: #339933;">.</span><span style="">Priority</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"p"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"2"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"The priority of an Issue which will be set."</span><span style="color: #339933;">)</span>
	flag<span style="color: #339933;">.</span><span style="">StringVar</span><span style="color: #339933;">(</span><span style="color: #339933;">&</span>flags<span style="color: #339933;">.</span><span style="">IssueKey</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"k"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">""</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"Issue key of an issue."</span><span style="color: #339933;">)</span>
	flag<span style="color: #339933;">.</span><span style="">StringVar</span><span style="color: #339933;">(</span><span style="color: #339933;">&</span>flags<span style="color: #339933;">.</span><span style="">Resolution</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"r"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"Done"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"Resolution when an issue is closed. Ex.: Done, Fixed, Won't fix."</span><span style="color: #339933;">)</span>
	flag<span style="color: #339933;">.</span><span style="">StringVar</span><span style="color: #339933;">(</span><span style="color: #339933;">&</span>flags<span style="color: #339933;">.</span><span style="">Title</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"t"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"Default Title"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"Title of an Issue."</span><span style="color: #339933;">)</span>
	flag<span style="color: #339933;">.</span><span style="">StringVar</span><span style="color: #339933;">(</span><span style="color: #339933;">&</span>flags<span style="color: #339933;">.</span><span style="">Project</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"o"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"IT"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"Define a Project to create a ticket in."</span><span style="color: #339933;">)</span>
	flag<span style="color: #339933;">.</span>Parse<span style="color: #339933;">()</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> <span style="color: #339933;">(</span>cred <span style="color: #339933;">*</span>Credentials<span style="color: #339933;">)</span> initConfig<span style="color: #339933;">()</span> <span style="color: #339933;">{</span>
	<span style="color: #b1b100; font-weight: bold;">if</span> _<span style="color: #339933;">,</span> err <span style="color: #339933;">:=</span> os<span style="color: #339933;">.</span>Stat<span style="color: #339933;">(</span>configFile<span style="color: #339933;">);</span> err <span style="color: #339933;">!=</span> <span style="color: #000000; font-weight: bold;">nil</span> <span style="color: #339933;">{</span>
		log<span style="color: #339933;">.</span>Fatalf<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Error using config file: %v"</span><span style="color: #339933;">,</span> err<span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
&nbsp;
	<span style="color: #b1b100; font-weight: bold;">if</span> _<span style="color: #339933;">,</span> err <span style="color: #339933;">:=</span> toml<span style="color: #339933;">.</span>DecodeFile<span style="color: #339933;">(</span>configFile<span style="color: #339933;">,</span> cred<span style="color: #339933;">);</span> err <span style="color: #339933;">!=</span> <span style="color: #000000; font-weight: bold;">nil</span> <span style="color: #339933;">{</span>
		log<span style="color: #339933;">.</span>Fatal<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Error during decoding toml config: "</span><span style="color: #339933;">,</span> err<span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> main<span style="color: #339933;">()</span> <span style="color: #339933;">{</span>
	<span style="color: #b1b100; font-weight: bold;">if</span> <span style="color: #000066;">len</span><span style="color: #339933;">(</span>flag<span style="color: #339933;">.</span>Args<span style="color: #339933;">())</span> &lt; <span style="color: #cc66cc;">1</span> <span style="color: #339933;">{</span>
		log<span style="color: #339933;">.</span>Fatal<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Please provide an action to take. Usage information:"</span><span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
	parameter <span style="color: #339933;">=</span> flag<span style="color: #339933;">.</span>Arg<span style="color: #339933;">(</span><span style="color: #cc66cc;"></span><span style="color: #339933;">)</span>
	<span style="color: #b1b100; font-weight: bold;">switch</span> parameter <span style="color: #339933;">{</span>
	<span style="color: #b1b100; font-weight: bold;">case</span> <span style="color: #cc66cc;">"close"</span><span style="color: #339933;">:</span>
		closeIssue<span style="color: #339933;">(</span>flags<span style="color: #339933;">.</span>IssueKey<span style="color: #339933;">)</span>
	<span style="color: #b1b100; font-weight: bold;">case</span> <span style="color: #cc66cc;">"start"</span><span style="color: #339933;">:</span>
		startIssue<span style="color: #339933;">(</span>flags<span style="color: #339933;">.</span>IssueKey<span style="color: #339933;">)</span>
	<span style="color: #b1b100; font-weight: bold;">case</span> <span style="color: #cc66cc;">"create"</span><span style="color: #339933;">:</span>
		createIssue<span style="color: #339933;">()</span>
	<span style="color: #339933;">}</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> closeIssue<span style="color: #339933;">(</span>issueKey <span style="color: #993333;">string</span><span style="color: #339933;">)</span> <span style="color: #339933;">{</span>
	<span style="color: #b1b100; font-weight: bold;">if</span> issueKey <span style="color: #339933;">==</span> <span style="color: #cc66cc;">""</span> <span style="color: #339933;">{</span>
		log<span style="color: #339933;">.</span><span style="">Fatal</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"Please provide an issueID with -k"</span><span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
	fmt<span style="color: #339933;">.</span><span style="">Println</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"Closing issue number: "</span><span style="color: #339933;">,</span> issueKey<span style="color: #339933;">)</span>
&nbsp;
	<span style="color: #b1b100; font-weight: bold;">var</span> trans Transition
&nbsp;
	<span style="color: #666666; font-style: italic;">//TODO: Add the ability to define a comment for the close reason</span>
	trans<span style="color: #339933;">.</span><span style="">Fields</span><span style="color: #339933;">.</span><span style="">Resolution</span><span style="color: #339933;">.</span><span style="">Name</span> <span style="color: #339933;">=</span> flags<span style="color: #339933;">.</span><span style="">Resolution</span>
	trans<span style="color: #339933;">.</span><span style="">Transition</span><span style="color: #339933;">.</span><span style="">ID</span> <span style="color: #339933;">=</span> <span style="color: #cc66cc;">"2"</span>
	marhsalledTrans<span style="color: #339933;">,</span> err <span style="color: #339933;">:=</span> json<span style="color: #339933;">.</span>Marshal<span style="color: #339933;">(</span>trans<span style="color: #339933;">)</span>
	<span style="color: #b1b100; font-weight: bold;">if</span> err <span style="color: #339933;">!=</span> <span style="color: #000000; font-weight: bold;">nil</span> <span style="color: #339933;">{</span>
		log<span style="color: #339933;">.</span>Fatal<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Error occured when marshaling transition: "</span><span style="color: #339933;">,</span> err<span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
	fmt<span style="color: #339933;">.</span><span style="">Println</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"Marshalled:"</span><span style="color: #339933;">,</span> trans<span style="color: #339933;">)</span>
	sendRequest<span style="color: #339933;">(</span>marhsalledTrans<span style="color: #339933;">,</span> <span style="color: #cc66cc;">"POST"</span><span style="color: #339933;">,</span> issueKey<span style="color: #339933;">+</span><span style="color: #cc66cc;">"/transitions?expand=transitions.fields"</span><span style="color: #339933;">)</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> startIssue<span style="color: #339933;">(</span>issueID <span style="color: #993333;">string</span><span style="color: #339933;">)</span> <span style="color: #339933;">{</span>
	<span style="color: #b1b100; font-weight: bold;">if</span> issueID <span style="color: #339933;">==</span> <span style="color: #cc66cc;">""</span> <span style="color: #339933;">{</span>
		log<span style="color: #339933;">.</span><span style="">Fatal</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"Please provide an issueID with -i"</span><span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
&nbsp;
	fmt<span style="color: #339933;">.</span><span style="">Println</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"Starting issue number:"</span><span style="color: #339933;">,</span> issueID<span style="color: #339933;">)</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> createIssue<span style="color: #339933;">()</span> <span style="color: #339933;">{</span>
	fmt<span style="color: #339933;">.</span>Println<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Creating new issue."</span><span style="color: #339933;">)</span>
	<span style="color: #b1b100; font-weight: bold;">var</span> issue Issue
	issue<span style="color: #339933;">.</span>Fields<span style="color: #339933;">.</span>Description <span style="color: #339933;">=</span> flags<span style="color: #339933;">.</span>Description
	issue<span style="color: #339933;">.</span>Fields<span style="color: #339933;">.</span>Priority<span style="color: #339933;">.</span>ID <span style="color: #339933;">=</span> flags<span style="color: #339933;">.</span>Priority
	issue<span style="color: #339933;">.</span>Fields<span style="color: #339933;">.</span>Summary <span style="color: #339933;">=</span> flags<span style="color: #339933;">.</span>Title
	issue<span style="color: #339933;">.</span>Fields<span style="color: #339933;">.</span>Project<span style="color: #339933;">.</span>Key <span style="color: #339933;">=</span> flags<span style="color: #339933;">.</span>Project
	issue<span style="color: #339933;">.</span>Fields<span style="color: #339933;">.</span>Issuetype<span style="color: #339933;">.</span>Name <span style="color: #339933;">=</span> <span style="color: #cc66cc;">"Task"</span>
	marshalledIssue<span style="color: #339933;">,</span> err <span style="color: #339933;">:=</span> json<span style="color: #339933;">.</span>Marshal<span style="color: #339933;">(</span>issue<span style="color: #339933;">)</span>
	<span style="color: #b1b100; font-weight: bold;">if</span> err <span style="color: #339933;">!=</span> <span style="color: #000000; font-weight: bold;">nil</span> <span style="color: #339933;">{</span>
		log<span style="color: #339933;">.</span>Fatal<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Error occured when Marshaling Issue:"</span><span style="color: #339933;">,</span> err<span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
	sendRequest<span style="color: #339933;">(</span>marshalledIssue<span style="color: #339933;">,</span> <span style="color: #cc66cc;">"POST"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">""</span><span style="color: #339933;">)</span>
<span style="color: #339933;">}</span>
&nbsp;
<span style="color: #993333;">func</span> sendRequest<span style="color: #339933;">(</span>jsonStr <span style="color: #339933;">[]</span><span style="color: #993333;">byte</span><span style="color: #339933;">,</span> method <span style="color: #993333;">string</span><span style="color: #339933;">,</span> url <span style="color: #993333;">string</span><span style="color: #339933;">)</span> <span style="color: #339933;">{</span>
	cred <span style="color: #339933;">:=</span> &Credentials<span style="color: #339933;">{}</span>
	cred<span style="color: #339933;">.</span>initConfig<span style="color: #339933;">()</span>
	fmt<span style="color: #339933;">.</span>Println<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Json:"</span><span style="color: #339933;">,</span> <span style="color: #993333;">string</span><span style="color: #339933;">(</span>jsonStr<span style="color: #339933;">))</span>
	req<span style="color: #339933;">,</span> err <span style="color: #339933;">:=</span> http<span style="color: #339933;">.</span>NewRequest<span style="color: #339933;">(</span>method<span style="color: #339933;">,</span> cred<span style="color: #339933;">.</span>URL<span style="color: #339933;">+</span>url<span style="color: #339933;">,</span> bytes<span style="color: #339933;">.</span>NewBuffer<span style="color: #339933;">(</span>jsonStr<span style="color: #339933;">))</span>
	req<span style="color: #339933;">.</span>Header<span style="color: #339933;">.</span>Set<span style="color: #339933;">(</span><span style="color: #cc66cc;">"Content-Type"</span><span style="color: #339933;">,</span> <span style="color: #cc66cc;">"application/json"</span><span style="color: #339933;">)</span>
	req<span style="color: #339933;">.</span>SetBasicAuth<span style="color: #339933;">(</span>cred<span style="color: #339933;">.</span>Username<span style="color: #339933;">,</span> cred<span style="color: #339933;">.</span>Password<span style="color: #339933;">)</span>
&nbsp;
	client <span style="color: #339933;">:=</span> &http<span style="color: #339933;">.</span>Client<span style="color: #339933;">{}</span>
	resp<span style="color: #339933;">,</span> err <span style="color: #339933;">:=</span> client<span style="color: #339933;">.</span>Do<span style="color: #339933;">(</span>req<span style="color: #339933;">)</span>
	<span style="color: #b1b100; font-weight: bold;">if</span> err <span style="color: #339933;">!=</span> <span style="color: #000000; font-weight: bold;">nil</span> <span style="color: #339933;">{</span>
		<span style="color: #000066;">panic</span><span style="color: #339933;">(</span>err<span style="color: #339933;">)</span>
	<span style="color: #339933;">}</span>
	<span style="color: #b1b100; font-weight: bold;">defer</span> resp<span style="color: #339933;">.</span>Body<span style="color: #339933;">.</span>Close<span style="color: #339933;">()</span>
&nbsp;
	fmt<span style="color: #339933;">.</span>Println<span style="color: #339933;">(</span><span style="color: #cc66cc;">"response Status:"</span><span style="color: #339933;">,</span> resp<span style="color: #339933;">.</span><span style="">Status</span><span style="color: #339933;">)</span>
	fmt<span style="color: #339933;">.</span><span style="">Println</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"response Headers:"</span><span style="color: #339933;">,</span> resp<span style="color: #339933;">.</span><span style="">Header</span><span style="color: #339933;">)</span>
	body<span style="color: #339933;">,</span> _ <span style="color: #339933;">:=</span> ioutil<span style="color: #339933;">.</span><span style="">ReadAll</span><span style="color: #339933;">(</span>resp<span style="color: #339933;">.</span><span style="">Body</span><span style="color: #339933;">)</span>
	fmt<span style="color: #339933;">.</span><span style="">Println</span><span style="color: #339933;">(</span><span style="color: #cc66cc;">"response Body:"</span><span style="color: #339933;">,</span> <span style="color: #993333;">string</span><span style="color: #339933;">(</span>body<span style="color: #339933;">))</span>
&nbsp;
<span style="color: #339933;">}</span></pre>
      </td>
    </tr>
  </table>
</div>

It can also be found under my github page: <a href="https://github.com/Skarlso/goprojects/tree/master/gojira" target="_blank">GoJira Github</a>.

Feel free to open up issues if you would like to use it and need some features which you would find interesting. Currently the username and password for the API are stored in a local config file in your home folder. Later on, I&#8217;ll add the ability to have a token rather than a username:password combination.

Thanks for reading!
  
Gergely.