---
title: How to Aggregate Tests with Jenkins with Aggregate Plugin on non-relating jobs
author: hannibal
layout: post
date: 2015-10-02
url: /2015/10/02/how-to-aggregate-tests-with-jenkins-with-aggregate-plugin-on-non-relating-jobs/
categories:
  - devops
  - problem solving
tags:
  - jenkins
---
Hello folks. 

Today, I would like to talk about something I came in contact with, and was hard to find a proper answer / solution for it.

So I&#8217;m writing this down to document my findings. Like the title says, this is about aggregating test result with Jenkins, using the plug-in provided. If you, like me, have a pipeline structure which do not work on the same artifact, but do have a upstream-downstream relationship, you will have a hard time configuring and making Aggregation work. So here is how, I fixed the issue. 

# Connection

In order for the aggregation to work, there needs to be an **artifact connection** between the upstream and downstream projects. And that is the key. But if you don&#8217;t have that, well, let&#8217;s create one. I have a parent job configured like this one. =>

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="xml" style="font-family:monospace;"><span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;?xml</span> <span style="color: #000066;">version</span>=<span style="color: #ff0000;">'1.0'</span> <span style="color: #000066;">encoding</span>=<span style="color: #ff0000;">'UTF-8'</span><span style="color: #000000; font-weight: bold;">?&gt;</span></span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;project<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;actions</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;description<span style="color: #000000; font-weight: bold;">&gt;</span></span><span style="color: #000000; font-weight: bold;">&lt;/description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;keepDependencies<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/keepDependencies<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;properties</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;scm</span> <span style="color: #000066;">class</span>=<span style="color: #ff0000;">"hudson.scm.NullSCM"</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;canRoam<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>true<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/canRoam<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;disabled<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/disabled<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;blockBuildWhenDownstreamBuilding<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/blockBuildWhenDownstreamBuilding<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;blockBuildWhenUpstreamBuilding<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/blockBuildWhenUpstreamBuilding<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;triggers</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;concurrentBuild<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/concurrentBuild<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;builders</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;publishers<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;hudson.tasks.test.AggregatedTestResultPublisher</span> <span style="color: #000066;">plugin</span>=<span style="color: #ff0000;">"junit@1.9"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;includeFailedBuilds<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/includeFailedBuilds<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/hudson.tasks.test.AggregatedTestResultPublisher<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;hudson.tasks.BuildTrigger<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;childProjects<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>ChildJob<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/childProjects<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;threshold<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
        <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;name<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>SUCCESS<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/name<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
        <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;ordinal<span style="color: #000000; font-weight: bold;">&gt;</span></span></span><span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/ordinal<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
        <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;color<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>BLUE<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/color<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
        <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;completeBuild<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>true<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/completeBuild<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/threshold<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/hudson.tasks.BuildTrigger<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/publishers<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;buildWrappers</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/project<span style="color: #000000; font-weight: bold;">&gt;</span></span></span></pre>
      </td>
    </tr>
  </table>
</div>

As you can see, it&#8217;s pretty basic. It isn&#8217;t much. It&#8217;s supposed to be a trigger job for downstream projects. You could have this one at anything. Maybe scheduled, or have some kind of gathering here of some results, and so on and so forth. The end part of the configuration is the interesting bit.

[<img src="http://ramblingsofaswtester.com/wp-content/uploads/2015/10/parentJobConfig1-150x150.png" alt="parentJobConfig" width="150" height="150" class="alignnone size-thumbnail wp-image-616" />][1]

Aggregation is setup, but it won&#8217;t work, because despite there being an upstream/downstream relationship, there also needs to be an artifact connection which uses **fingerprinting**. Fingerprinting for Jenkins is needed in oder to make the physical connection between the jobs via hashes. This is what you will get if that is not setup:

[<img src="http://ramblingsofaswtester.com/wp-content/uploads/2015/10/statusBeforeFingerprint-150x150.png" alt="statusBeforeFingerprint" width="150" height="150" class="alignnone size-thumbnail wp-image-615" />][2]

But if there is no artifact between them, what do you do? You create one.

# The Artifact which Binds Us

Adding a simple **timestamp file** is enough to make a connection. So let&#8217;s do that. This is how it will look like =>

[<img src="http://ramblingsofaswtester.com/wp-content/uploads/2015/10/statusAfterFingerprint-150x150.png" alt="statusAfterFingerprint" width="150" height="150" class="alignnone size-thumbnail wp-image-614" />][3]

The important bits about this picture are the small echo which simply creates a file which will contain some time stamp data, and after that the archive artifact, which also fingerprints that file, marking it with a hash which identifies this job as using that particular artifact. 

Now, the next step is to create the connection. For that, you need the artifact copy plugin => <a href="https://wiki.jenkins-ci.org/display/JENKINS/Copy+Artifact+Plugin" target="_blank">Copy Artifact Plugin</a>.

With this, we create the childs configuration like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="xml" style="font-family:monospace;"><span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;?xml</span> <span style="color: #000066;">version</span>=<span style="color: #ff0000;">'1.0'</span> <span style="color: #000066;">encoding</span>=<span style="color: #ff0000;">'UTF-8'</span><span style="color: #000000; font-weight: bold;">?&gt;</span></span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;project<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;actions</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;description<span style="color: #000000; font-weight: bold;">&gt;</span></span><span style="color: #000000; font-weight: bold;">&lt;/description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;keepDependencies<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/keepDependencies<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;properties</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;scm</span> <span style="color: #000066;">class</span>=<span style="color: #ff0000;">"hudson.plugins.git.GitSCM"</span> <span style="color: #000066;">plugin</span>=<span style="color: #ff0000;">"git@2.4.0"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;configVersion<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>2<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/configVersion<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;userRemoteConfigs<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;hudson.plugins.git.UserRemoteConfig<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
        <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;url<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>https://github.com/Skarlso/DataMung.git<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/url<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/hudson.plugins.git.UserRemoteConfig<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/userRemoteConfigs<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;branches<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;hudson.plugins.git.BranchSpec<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
        <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;name<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>*/master<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/name<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/hudson.plugins.git.BranchSpec<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/branches<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;doGenerateSubmoduleConfigurations<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/doGenerateSubmoduleConfigurations<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;submoduleCfg</span> <span style="color: #000066;">class</span>=<span style="color: #ff0000;">"list"</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;extensions</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/scm<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;canRoam<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>true<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/canRoam<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;disabled<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/disabled<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;blockBuildWhenDownstreamBuilding<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/blockBuildWhenDownstreamBuilding<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;blockBuildWhenUpstreamBuilding<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/blockBuildWhenUpstreamBuilding<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;triggers</span><span style="color: #000000; font-weight: bold;">/&gt;</span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;concurrentBuild<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/concurrentBuild<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;builders<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;hudson.plugins.gradle.Gradle</span> <span style="color: #000066;">plugin</span>=<span style="color: #ff0000;">"gradle@1.24"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;description<span style="color: #000000; font-weight: bold;">&gt;</span></span><span style="color: #000000; font-weight: bold;">&lt;/description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;switches<span style="color: #000000; font-weight: bold;">&gt;</span></span><span style="color: #000000; font-weight: bold;">&lt;/switches<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;tasks<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>assemble check<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/tasks<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;rootBuildScriptDir<span style="color: #000000; font-weight: bold;">&gt;</span></span><span style="color: #000000; font-weight: bold;">&lt;/rootBuildScriptDir<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;buildFile<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>build.gradle<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/buildFile<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;gradleName<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>(Default)<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/gradleName<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;useWrapper<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>true<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/useWrapper<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;makeExecutable<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/makeExecutable<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;fromRootBuildScriptDir<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>true<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/fromRootBuildScriptDir<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;useWorkspaceAsHome<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/useWorkspaceAsHome<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/hudson.plugins.gradle.Gradle<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;hudson.plugins.copyartifact.CopyArtifact</span> <span style="color: #000066;">plugin</span>=<span style="color: #ff0000;">"copyartifact@1.36"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;project<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>ParentJob<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/project<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;filter<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>timestamp.data<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/filter<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;target<span style="color: #000000; font-weight: bold;">&gt;</span></span><span style="color: #000000; font-weight: bold;">&lt;/target<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;excludes<span style="color: #000000; font-weight: bold;">&gt;</span></span><span style="color: #000000; font-weight: bold;">&lt;/excludes<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;selector</span> <span style="color: #000066;">class</span>=<span style="color: #ff0000;">"hudson.plugins.copyartifact.TriggeredBuildSelector"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
        <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;upstreamFilterStrategy<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>UseGlobalSetting<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/upstreamFilterStrategy<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/selector<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;doNotFingerprintArtifacts<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/doNotFingerprintArtifacts<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/hudson.plugins.copyartifact.CopyArtifact<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/builders<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;publishers<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;hudson.tasks.junit.JUnitResultArchiver</span> <span style="color: #000066;">plugin</span>=<span style="color: #ff0000;">"junit@1.9"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;testResults<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>build/test-results/*.xml<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/testResults<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;keepLongStdio<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/keepLongStdio<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;healthScaleFactor<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>1.0<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/healthScaleFactor<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/hudson.tasks.junit.JUnitResultArchiver<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/publishers<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;buildWrappers<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;hudson.plugins.ws__cleanup.PreBuildCleanup</span> <span style="color: #000066;">plugin</span>=<span style="color: #ff0000;">"ws-cleanup@0.28"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;deleteDirs<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>false<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/deleteDirs<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;cleanupParameter<span style="color: #000000; font-weight: bold;">&gt;</span></span><span style="color: #000000; font-weight: bold;">&lt;/cleanupParameter<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
      <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;externalDelete<span style="color: #000000; font-weight: bold;">&gt;</span></span><span style="color: #000000; font-weight: bold;">&lt;/externalDelete<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/hudson.plugins.ws__cleanup.PreBuildCleanup<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/buildWrappers<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/project<span style="color: #000000; font-weight: bold;">&gt;</span></span></span></pre>
      </td>
    </tr>
  </table>
</div>

Again, the improtant bit is this:
  
[<img src="http://ramblingsofaswtester.com/wp-content/uploads/2015/10/childJobWithArtifactCopy-150x150.png" alt="childJobWithArtifactCopy" width="150" height="150" class="alignnone size-thumbnail wp-image-611" />][4]

After the copy is setup, we launch our parent job and if everything is correct, you should see something like this:

[<img src="http://ramblingsofaswtester.com/wp-content/uploads/2015/10/resultAfterArtifactCopySuccess-150x150.png" alt="resultAfterArtifactCopySuccess" width="150" height="150" class="alignnone size-thumbnail wp-image-613" />][5]

# Wrapping it Up

For final words, important bit to take away from this is that you need an **artifact connection between the jobs** to make this work. Whatever your downstream / upstream connection is, it doesn&#8217;t matter. Also, there can be a problem that you have everything set up, and there are artifacts which bind the jobs together but you still can&#8217;t see the results, then your best option is to specify the jobs BY NAME in the aggregate test plug-in like this:

[<img src="http://ramblingsofaswtester.com/wp-content/uploads/2015/10/aggregatingByName-150x150.png" alt="aggregatingByName" width="150" height="150" class="alignnone size-thumbnail wp-image-622" />][6]

I know this is a pain if there are multiple jobs, but at least, jenkins is providing you with Autoexpande once you start typing.

Of course this also works with multiple downstream jobs if they copy the artifact to themselves. 

Any questions, please feel free to comment and I will answer to the best of my knowledge.

Cheers,
  
Gergely.

 [1]: http://ramblingsofaswtester.com/wp-content/uploads/2015/10/parentJobConfig1.png
 [2]: http://ramblingsofaswtester.com/wp-content/uploads/2015/10/statusBeforeFingerprint.png
 [3]: http://ramblingsofaswtester.com/wp-content/uploads/2015/10/statusAfterFingerprint.png
 [4]: http://ramblingsofaswtester.com/wp-content/uploads/2015/10/childJobWithArtifactCopy.png
 [5]: http://ramblingsofaswtester.com/wp-content/uploads/2015/10/resultAfterArtifactCopySuccess.png
 [6]: http://ramblingsofaswtester.com/wp-content/uploads/2015/10/aggregatingByName.png