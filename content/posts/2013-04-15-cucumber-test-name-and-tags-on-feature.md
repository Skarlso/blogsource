---
title: Cucumber Test Name and Tags on Feature
author: hannibal
layout: post
date: 2013-04-15
url: /2013/04/15/cucumber-test-name-and-tags-on-feature/
categories:
  - java
  - problem solving
  - programming
  - testing
tags:
  - cucumber-jvm
---
Hello everybody.

I would like to show you a gem today that I found out.

Apparently there is no easy way to get to the name of an executing cucumber scenario in cucumber-jvm

You can try something like that:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="java" style="font-family:monospace;">@After <span style="color: #666666; font-style: italic;">//this is cucumbers @Afters</span>
<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> <span style="color: #000066; font-weight: bold;">void</span> afterExecution<span style="color: #009900;">&#40;</span>Scenario scenario<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
    logger.<span style="color: #006633;">log</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"The status of the test is: "</span> <span style="color: #339933;">+</span> scenario.<span style="color: #006633;">getStatus</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
<span style="color: #009900;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

But that isn&#8217;t giving you too much now is it? And the API of scenario is as small as it can get. It offers you four options:

  * Ember
  * getStatus
  * isFailed
  * write

That doesn&#8217;t help me. I wanted to get the name of the executed feature and the tags on that particular feature. I thought that&#8217;s got to be as easy as just getting a scenario accessing the feature and get the tags. Hooooowww boy I was wrong.

I ended up with this&#8230;.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="java" style="font-family:monospace;">            <span style="color: #003399;">Field</span> f <span style="color: #339933;">=</span> scenario.<span style="color: #006633;">getClass</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>.<span style="color: #006633;">getDeclaredField</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"reporter"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            f.<span style="color: #006633;">setAccessible</span><span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">true</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            JUnitReporter reporter <span style="color: #339933;">=</span> <span style="color: #009900;">&#40;</span>JUnitReporter<span style="color: #009900;">&#41;</span> f.<span style="color: #006633;">get</span><span style="color: #009900;">&#40;</span>scenario<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
            <span style="color: #003399;">Field</span> executionRunnerField <span style="color: #339933;">=</span> reporter.<span style="color: #006633;">getClass</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>.<span style="color: #006633;">getDeclaredField</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"executionUnitRunner"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            executionRunnerField.<span style="color: #006633;">setAccessible</span><span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">true</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            ExecutionUnitRunner executionUnitRunner <span style="color: #339933;">=</span> <span style="color: #009900;">&#40;</span>ExecutionUnitRunner<span style="color: #009900;">&#41;</span> executionRunnerField.<span style="color: #006633;">get</span><span style="color: #009900;">&#40;</span>reporter<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
            <span style="color: #003399;">Field</span> cucumberScenarioField <span style="color: #339933;">=</span> executionUnitRunner.<span style="color: #006633;">getClass</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>.<span style="color: #006633;">getDeclaredField</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"cucumberScenario"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            cucumberScenarioField.<span style="color: #006633;">setAccessible</span><span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">true</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            CucumberScenario cucumberScenario <span style="color: #339933;">=</span> <span style="color: #009900;">&#40;</span>CucumberScenario<span style="color: #009900;">&#41;</span> cucumberScenarioField.<span style="color: #006633;">get</span><span style="color: #009900;">&#40;</span>executionUnitRunner<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
            <span style="color: #003399;">Field</span> cucumberBackgroundField <span style="color: #339933;">=</span> cucumberScenario.<span style="color: #006633;">getClass</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>.<span style="color: #006633;">getDeclaredField</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"cucumberBackground"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            cucumberBackgroundField.<span style="color: #006633;">setAccessible</span><span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">true</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            CucumberBackground cucumberBackground <span style="color: #339933;">=</span> <span style="color: #009900;">&#40;</span>CucumberBackground<span style="color: #009900;">&#41;</span> cucumberBackgroundField.<span style="color: #006633;">get</span><span style="color: #009900;">&#40;</span>cucumberScenario<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
            <span style="color: #003399;">Field</span> cucumberFeatureField <span style="color: #339933;">=</span> cucumberBackground.<span style="color: #006633;">getClass</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>.<span style="color: #006633;">getSuperclass</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>.<span style="color: #006633;">getDeclaredField</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"cucumberFeature"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            cucumberFeatureField.<span style="color: #006633;">setAccessible</span><span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">true</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            CucumberFeature cucumberFeature <span style="color: #339933;">=</span> <span style="color: #009900;">&#40;</span>CucumberFeature<span style="color: #009900;">&#41;</span> cucumberFeatureField.<span style="color: #006633;">get</span><span style="color: #009900;">&#40;</span>cucumberBackground<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
      </td>
    </tr>
  </table>
</div>

Ohhhhh yes! The fields which I wanted were all private and not accessible. I&#8217;m sure there was a reason behind this decision but if it was sensible it eludes me. But in the world of programming nothing is impossible they say so there.

In cucumberFeature there will be everything what you need. Tags, Names, Tests, Execution time. Everything.

I know that cucumber runs with jUnit so if there is a better way to do this please for the love of my sanity share it with me.

Thank you for reading.
  
And as always,
  
Have a nice day.
  
G.