+++
author = "hannibal"
categories = ["devops", "problem solving"]
date = "2015-07-16"
type = "post"
tags = ["jenkins", "Packer", "vagrant"]
title = "Selenium Testing with Packer and Vagrant"
url = "/2015/07/16/selenium-testing-with-packer-and-vagrant/"

+++

So, recently, the tester team talked to me, that their build takes too long, and why is that? A quick look at their configuration and build scripts showed me, that they are actually using a vagrant box, which never gets destroyed or re-started at least. To remedy this problem, I came up with the following solution&#8230;

<!--more-->

# Same old&#8230;

Same as in my previous post, we are going to build a Windows Machine for this purpose. The only addition to my previous settings, will be some Java install, downloading selenium and installing Chrome, and Firefox.

# Installation

#### Answer File

Here is the configuration and setup of Windows before the provision phase.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="xml" style="font-family:monospace;">...
               <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;SynchronousCommand</span> <span style="color: #000066;">wcm:action</span>=<span style="color: #ff0000;">"add"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
                  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;CommandLine<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\jdk_inst.ps1 -AutoStart<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/CommandLine<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;Description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>Install Java<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/Description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;Order<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>103<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/Order<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                  <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;RequiresUserInput<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>true<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/RequiresUserInput<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
               <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/SynchronousCommand<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
...</pre>
      </td>
    </tr>
  </table>
</div>

This is the part were I&#8217;m installing Java. The script for the jdk_inst.ps1 is in my previous post, but I&#8217;ll paste it here for ease of read.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="powershell" style="font-family:monospace;"><span style="color: #0000FF;">function</span> LogWrite <span style="color: #000000;">&#123;</span>
   <span style="color: #0000FF;">Param</span> <span style="color: #000000;">&#40;</span><span style="color: #000000;">&#91;</span><span style="color: #008080;">string</span><span style="color: #000000;">&#93;</span><span style="color: #800080;">$logstring</span><span style="color: #000000;">&#41;</span>
   <span style="color: #800080;">$now</span> <span style="color: pink;">=</span> <span style="color: #008080; font-weight: bold;">Get-Date</span> <span style="color: #008080; font-style: italic;">-format</span> s
   <span style="color: #008080; font-weight: bold;">Add-Content</span> <span style="color: #800080;">$Logfile</span> <span style="color: #008080; font-style: italic;">-value</span> <span style="color: #800000;">"$now $logstring"</span>
   <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800080;">$logstring</span>
<span style="color: #000000;">&#125;</span>
&nbsp;
<span style="color: #800080;">$Logfile</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\Windows\Temp\jdk-install.log"</span>
&nbsp;
<span style="color: #800080;">$JDK_VER</span><span style="color: pink;">=</span><span style="color: #800000;">"7u75"</span>
<span style="color: #800080;">$JDK_FULL_VER</span><span style="color: pink;">=</span><span style="color: #800000;">"7u75-b13"</span>
<span style="color: #800080;">$JDK_PATH</span><span style="color: pink;">=</span><span style="color: #800000;">"1.7.0_75"</span>
<span style="color: #800080;">$source86</span> <span style="color: pink;">=</span> <span style="color: #800000;">"http://download.oracle.com/otn-pub/java/jdk/$JDK_FULL_VER/jdk-$JDK_VER-windows-i586.exe"</span>
<span style="color: #800080;">$source64</span> <span style="color: pink;">=</span> <span style="color: #800000;">"http://download.oracle.com/otn-pub/java/jdk/$JDK_FULL_VER/jdk-$JDK_VER-windows-x64.exe"</span>
<span style="color: #800080;">$destination86</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\Windows\Temp\$JDK_VER-x86.exe"</span>
<span style="color: #800080;">$destination64</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\Windows\Temp\$JDK_VER-x64.exe"</span>
<span style="color: #800080;">$client</span> <span style="color: pink;">=</span> <span style="color: #008080; font-weight: bold;">new-object</span> System.Net.WebClient
<span style="color: #800080;">$cookie</span> <span style="color: pink;">=</span> <span style="color: #800000;">"oraclelicense=accept-securebackup-cookie"</span>
<span style="color: #800080;">$client</span>.Headers.Add<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#91;</span>System.Net.HttpRequestHeader<span style="color: #000000;">&#93;</span>::Cookie<span style="color: pink;">,</span> <span style="color: #800080;">$cookie</span><span style="color: #000000;">&#41;</span>
&nbsp;
LogWrite <span style="color: #800000;">"Setting Execution Policy level to Bypass"</span>
<span style="color: #008080; font-weight: bold;">Set-ExecutionPolicy</span> <span style="color: #008080; font-style: italic;">-Scope</span> CurrentUser <span style="color: #008080; font-style: italic;">-ExecutionPolicy</span> Bypass <span style="color: #008080; font-style: italic;">-Force</span>
&nbsp;
LogWrite <span style="color: #800000;">'Checking if Java is already installed'</span>
<span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800000;">"c:\Program Files (x86)\Java"</span><span style="color: #000000;">&#41;</span> <span style="color: #FF0000;">-Or</span> <span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800000;">"c:\Program Files\Java"</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #800000;">'No need to Install Java'</span>
    Exit
<span style="color: #000000;">&#125;</span>
&nbsp;
LogWrite <span style="color: #800000;">'Downloading x86 to $destination86'</span>
try <span style="color: #000000;">&#123;</span>
  <span style="color: #800080;">$client</span>.downloadFile<span style="color: #000000;">&#40;</span><span style="color: #800080;">$source86</span><span style="color: pink;">,</span> <span style="color: #800080;">$destination86</span><span style="color: #000000;">&#41;</span>
  <span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: pink;">!</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800080;">$destination86</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
      LogWrite <span style="color: #800000;">"Downloading $destination86 failed"</span>
      Exit
  <span style="color: #000000;">&#125;</span>
  LogWrite <span style="color: #800000;">'Downloading x64 to $destination64'</span>
&nbsp;
  <span style="color: #800080;">$client</span>.downloadFile<span style="color: #000000;">&#40;</span><span style="color: #800080;">$source64</span><span style="color: pink;">,</span> <span style="color: #800080;">$destination64</span><span style="color: #000000;">&#41;</span>
  <span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: pink;">!</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800080;">$destination64</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
      LogWrite <span style="color: #800000;">"Downloading $destination64 failed"</span>
      Exit
  <span style="color: #000000;">&#125;</span>
<span style="color: #000000;">&#125;</span> catch <span style="color: #000000;">&#91;</span>Exception<span style="color: #000000;">&#93;</span> <span style="color: #000000;">&#123;</span>
  LogWrite <span style="color: #800000;">'$_.Exception is'</span> <span style="color: #000080;">$_</span>.Exception
<span style="color: #000000;">&#125;</span>
&nbsp;
try <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #800000;">'Installing JDK-x64'</span>
    <span style="color: #800080;">$proc1</span> <span style="color: pink;">=</span> Start<span style="color: pink;">-</span>Process <span style="color: #008080; font-style: italic;">-FilePath</span> <span style="color: #800000;">"$destination64"</span> <span style="color: #008080; font-style: italic;">-ArgumentList</span> <span style="color: #800000;">"/s REBOOT=ReallySuppress"</span> <span style="color: #008080; font-style: italic;">-Wait</span> <span style="color: #008080; font-style: italic;">-PassThru</span>
    <span style="color: #800080;">$proc1</span>.waitForExit<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#41;</span>
    LogWrite <span style="color: #800000;">'Installation Done.'</span>
&nbsp;
    LogWrite <span style="color: #800000;">'Installing JDK-x86'</span>
    <span style="color: #800080;">$proc2</span> <span style="color: pink;">=</span> Start<span style="color: pink;">-</span>Process <span style="color: #008080; font-style: italic;">-FilePath</span> <span style="color: #800000;">"$destination86"</span> <span style="color: #008080; font-style: italic;">-ArgumentList</span> <span style="color: #800000;">"/s REBOOT=ReallySuppress"</span> <span style="color: #008080; font-style: italic;">-Wait</span> <span style="color: #008080; font-style: italic;">-PassThru</span>
    <span style="color: #800080;">$proc2</span>.waitForExit<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#41;</span>
    LogWrite <span style="color: #800000;">'Installtion Done.'</span>
<span style="color: #000000;">&#125;</span> catch <span style="color: #000000;">&#91;</span>exception<span style="color: #000000;">&#93;</span> <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #800000;">'$_ is'</span> <span style="color: #000080;">$_</span>
    LogWrite <span style="color: #800000;">'$_.GetType().FullName is'</span> <span style="color: #000080;">$_</span>.GetType<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#41;</span>.FullName
    LogWrite <span style="color: #800000;">'$_.Exception is'</span> <span style="color: #000080;">$_</span>.Exception
    LogWrite <span style="color: #800000;">'$_.Exception.GetType().FullName is'</span> <span style="color: #000080;">$_</span>.Exception.GetType<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#41;</span>.FullName
    LogWrite <span style="color: #800000;">'$_.Exception.Message is'</span> <span style="color: #000080;">$_</span>.Exception.Message
<span style="color: #000000;">&#125;</span>
&nbsp;
<span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800000;">"c:\Program Files (x86)\Java"</span><span style="color: #000000;">&#41;</span> <span style="color: #FF0000;">-Or</span> <span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800000;">"c:\Program Files\Java"</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #800000;">'Java installed successfully.'</span>
<span style="color: #000000;">&#125;</span> <span style="color: #0000FF;">else</span> <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #800000;">'Java install Failed!'</span>
<span style="color: #000000;">&#125;</span>
LogWrite <span style="color: #800000;">'Setting up Path variables.'</span>
<span style="color: #000000;">&#91;</span>System.Environment<span style="color: #000000;">&#93;</span>::SetEnvironmentVariable<span style="color: #000000;">&#40;</span><span style="color: #800000;">"JAVA_HOME"</span><span style="color: pink;">,</span> <span style="color: #800000;">"c:\Program Files (x86)\Java\jdk$JDK_PATH"</span><span style="color: pink;">,</span> <span style="color: #800000;">"Machine"</span><span style="color: #000000;">&#41;</span>
<span style="color: #000000;">&#91;</span>System.Environment<span style="color: #000000;">&#93;</span>::SetEnvironmentVariable<span style="color: #000000;">&#40;</span><span style="color: #800000;">"PATH"</span><span style="color: pink;">,</span> <span style="color: #800080;">$Env</span>:Path <span style="color: pink;">+</span> <span style="color: #800000;">";c:\Program Files (x86)\Java\jdk$JDK_PATH\bin"</span><span style="color: pink;">,</span> <span style="color: #800000;">"Machine"</span><span style="color: #000000;">&#41;</span>
LogWrite <span style="color: #800000;">'Done. Goodbye.'</span></pre>
      </td>
    </tr>
  </table>
</div>

This installs both x86 and 64 bit version of Java.

# Provision

I decided to put these into the provision phase to get log messages written out properly. Because in the unattended file, you can&#8217;t see any progress.

#### Chrome And Firefox

Installing these two proved a little bit more difficult. Chrome didn&#8217;t really like me to download their installer without accepting something first, like Java. Luckily, after a LOT of digging, I found a chrome installer which lets you install silently. Here is the script to install the two.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="powershell" style="font-family:monospace;"><span style="color: #0000FF;">function</span> LogWrite <span style="color: #000000;">&#123;</span>
    <span style="color: #0000FF;">Param</span> <span style="color: #000000;">&#40;</span><span style="color: #000000;">&#91;</span><span style="color: #008080;">string</span><span style="color: #000000;">&#93;</span><span style="color: #800080;">$logstring</span><span style="color: #000000;">&#41;</span>
    <span style="color: #800080;">$now</span> <span style="color: pink;">=</span> <span style="color: #008080; font-weight: bold;">Get-Date</span> <span style="color: #008080; font-style: italic;">-format</span> s
    <span style="color: #008080; font-weight: bold;">Add-Content</span> <span style="color: #800080;">$Logfile</span> <span style="color: #008080; font-style: italic;">-value</span> <span style="color: #800000;">"$now $logstring"</span>
    <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800080;">$logstring</span>
<span style="color: #000000;">&#125;</span>
&nbsp;
<span style="color: #0000FF;">function</span> CheckLocation <span style="color: #000000;">&#123;</span>
    <span style="color: #0000FF;">Param</span> <span style="color: #000000;">&#40;</span><span style="color: #000000;">&#91;</span><span style="color: #008080;">string</span><span style="color: #000000;">&#93;</span><span style="color: #800080;">$location</span><span style="color: #000000;">&#41;</span>
    <span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: pink;">!</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span>  <span style="color: #800080;">$location</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
        <span style="color: #0000FF;">throw</span> <span style="color: #000000;">&#91;</span>System.IO.FileNotFoundException<span style="color: #000000;">&#93;</span> <span style="color: #800000;">"Could not download to Destination $location."</span>
    <span style="color: #000000;">&#125;</span>
<span style="color: #000000;">&#125;</span>
&nbsp;
<span style="color: #800080;">$Logfile</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\Windows\Temp\chrome-firefox-install.log"</span>
&nbsp;
<span style="color: #800080;">$chrome_source</span> <span style="color: pink;">=</span> <span style="color: #800000;">"http://dl.google.com/chrome/install/375.126/chrome_installer.exe"</span>
<span style="color: #800080;">$chrome_destination</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\Windows\Temp\chrome_installer.exe"</span>
<span style="color: #800080;">$firefox_source</span> <span style="color: pink;">=</span> <span style="color: #800000;">"https://download-installer.cdn.mozilla.net/pub/firefox/releases/39.0/win32/hu/Firefox%20Setup%2039.0.exe"</span>
<span style="color: #800080;">$firefox_destination</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\Windows\Temp\firefoxinstaller.exe"</span>
&nbsp;
LogWrite <span style="color: #800000;">'Starting to download files.'</span>
try <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #800000;">'Downloading Chrome...'</span>
    <span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">New-Object</span> System.Net.WebClient<span style="color: #000000;">&#41;</span>.DownloadFile<span style="color: #000000;">&#40;</span><span style="color: #800080;">$chrome_source</span><span style="color: pink;">,</span> <span style="color: #800080;">$chrome_destination</span><span style="color: #000000;">&#41;</span>
    CheckLocation <span style="color: #800080;">$chrome_destination</span>
    LogWrite <span style="color: #800000;">'Done...'</span>
    LogWrite <span style="color: #800000;">'Downloading Firefox...'</span>
    <span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">New-Object</span> System.Net.WebClient<span style="color: #000000;">&#41;</span>.DownloadFile<span style="color: #000000;">&#40;</span><span style="color: #800080;">$firefox_source</span><span style="color: pink;">,</span> <span style="color: #800080;">$firefox_destination</span><span style="color: #000000;">&#41;</span>
    CheckLocation <span style="color: #800080;">$firefox_destination</span>
<span style="color: #000000;">&#125;</span> catch <span style="color: #000000;">&#91;</span>Exception<span style="color: #000000;">&#93;</span> <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #800000;">"Exception during download. Probable cause could be that the directory or the file didn't exist."</span>
    LogWrite <span style="color: #800000;">'$_.Exception is'</span> <span style="color: #000080;">$_</span>.Exception
<span style="color: #000000;">&#125;</span>
&nbsp;
LogWrite <span style="color: #800000;">'Starting firefox install process.'</span>
try <span style="color: #000000;">&#123;</span>
    Start<span style="color: pink;">-</span>Process <span style="color: #008080; font-style: italic;">-FilePath</span> <span style="color: #800080;">$firefox_destination</span> <span style="color: #008080; font-style: italic;">-ArgumentList</span> <span style="color: #800000;">"-ms"</span> <span style="color: #008080; font-style: italic;">-Wait</span> <span style="color: #008080; font-style: italic;">-PassThru</span>
<span style="color: #000000;">&#125;</span> catch <span style="color: #000000;">&#91;</span>Exception<span style="color: #000000;">&#93;</span> <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #800000;">'Exception during install process.'</span>
    LogWrite <span style="color: #800000;">'$_.Exception is'</span> <span style="color: #000080;">$_</span>.Exception
<span style="color: #000000;">&#125;</span>
LogWrite <span style="color: #800000;">'Starting chrome install process.'</span>
&nbsp;
try <span style="color: #000000;">&#123;</span>
    Start<span style="color: pink;">-</span>Process <span style="color: #008080; font-style: italic;">-FilePath</span> <span style="color: #800080;">$chrome_destination</span> <span style="color: #008080; font-style: italic;">-ArgumentList</span> <span style="color: #800000;">"/silent /install"</span> <span style="color: #008080; font-style: italic;">-Wait</span> <span style="color: #008080; font-style: italic;">-PassThru</span>
<span style="color: #000000;">&#125;</span> catch <span style="color: #000000;">&#91;</span>Exception<span style="color: #000000;">&#93;</span> <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #800000;">'Exception during install process.'</span>
    LogWrite <span style="color: #800000;">'$_.Exception is'</span> <span style="color: #000080;">$_</span>.Exception
<span style="color: #000000;">&#125;</span>
&nbsp;
LogWrite <span style="color: #800000;">'All done. Goodbye.'</span></pre>
      </td>
    </tr>
  </table>
</div>

They both install silently. Pretty neat. 

#### Selenium

This only has to be downloaded, so this is pretty simple. Vagrant will handle the startup of course when it does a vagrant up.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="powershell" style="font-family:monospace;"><span style="color: #0000FF;">function</span> LogWrite <span style="color: #000000;">&#123;</span>
   <span style="color: #0000FF;">Param</span> <span style="color: #000000;">&#40;</span><span style="color: #000000;">&#91;</span><span style="color: #008080;">string</span><span style="color: #000000;">&#93;</span><span style="color: #800080;">$logstring</span><span style="color: #000000;">&#41;</span>
   <span style="color: #800080;">$now</span> <span style="color: pink;">=</span> <span style="color: #008080; font-weight: bold;">Get-Date</span> <span style="color: #008080; font-style: italic;">-format</span> s
   <span style="color: #008080; font-weight: bold;">Add-Content</span> <span style="color: #800080;">$Logfile</span> <span style="color: #008080; font-style: italic;">-value</span> <span style="color: #800000;">"$now $logstring"</span>
   <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800080;">$logstring</span>
<span style="color: #000000;">&#125;</span>
&nbsp;
<span style="color: #800080;">$Logfile</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\Windows\Temp\selenium-install.log"</span>
&nbsp;
<span style="color: #800080;">$source</span> <span style="color: pink;">=</span> <span style="color: #800000;">"http://selenium-release.storage.googleapis.com/2.46/selenium-server-standalone-2.46.0.jar"</span>
<span style="color: #800080;">$destination</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\Windows\Temp\selenium-server.jar"</span>
LogWrite <span style="color: #800000;">'Starting to download selenium file.'</span>
try <span style="color: #000000;">&#123;</span>
  <span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">New-Object</span> System.Net.WebClient<span style="color: #000000;">&#41;</span>.DownloadFile<span style="color: #000000;">&#40;</span><span style="color: #800080;">$source</span><span style="color: pink;">,</span> <span style="color: #800080;">$destination</span><span style="color: #000000;">&#41;</span>
<span style="color: #000000;">&#125;</span> catch <span style="color: #000000;">&#91;</span>Exception<span style="color: #000000;">&#93;</span> <span style="color: #000000;">&#123;</span>
  LogWrite <span style="color: #800000;">"Exception during download. Probable cause could be that the directory or the file didn't exist."</span>
  LogWrite <span style="color: #800000;">'$_.Exception is'</span> <span style="color: #000080;">$_</span>.Exception
<span style="color: #000000;">&#125;</span>
LogWrite <span style="color: #800000;">'Download done. Checking if file exists.'</span>
<span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: pink;">!</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800080;">$destination</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
  LogWrite <span style="color: #800000;">'Downloading dotnet Failed!'</span>
<span style="color: #000000;">&#125;</span> <span style="color: #0000FF;">else</span> <span style="color: #000000;">&#123;</span>
  LogWrite <span style="color: #800000;">'Download successful.'</span>
<span style="color: #000000;">&#125;</span>
&nbsp;
LogWrite <span style="color: #800000;">'All done. Goodbye.'</span></pre>
      </td>
    </tr>
  </table>
</div>

Straightforward.

#### The Packer Json File

So putting this all together, here is the Packer JSON file for this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="json" style="font-family:monospace;">{
      "variables": {
      "vm_name": "win7x64selenium",
      "output_dir": "output_win7_x64_selenium",
      "vagrant_box_output": "box_output",
      "cpu_number": "2",
      "memory_size": "4096",
      "machine_type": "pc-1.2",
      "accelerator": "kvm",
      "disk_format": "qcow2",
      "disk_interface": "virtio",
      "net_device": "virtio-net",
      "cpu_model": "host",
      "disk_cache": "writeback",
      "disk_io": "native"
   },
&nbsp;
  "builders": [
    {
      "type": "virtualbox-iso",
      "iso_url": "/home/user/vms/windows7.iso",
      "iso_checksum_type": "sha1",
      "iso_checksum": "0BCFC54019EA175B1EE51F6D2B207A3D14DD2B58",
      "headless": true,
      "boot_wait": "2m",
      "ssh_username": "vagrant",
      "ssh_password": "vagrant",
      "ssh_wait_timeout": "8h",
      "shutdown_command": "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\"",
      "guest_os_type": "Windows7_64",
      "disk_size": 61440,
      "floppy_files": [
        "./answer_files/7-selenium/Autounattend.xml",
        "./scripts/dis-updates.ps1",
        "./scripts/microsoft-updates.bat",
        "./scripts/openssh.ps1",
        "./scripts/jdk_inst.ps1"
      ],
      "vboxmanage": [
        [
          "modifyvm",
          "{{.Name}}",
          "--memory",
          "{{user `memory_size`}}"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--cpus",
          "{{user `cpu_number`}}"
        ]
      ]
    }
  ],
  "provisioners": [
    {
      "type": "powershell",
      "scripts" : [
        "./scripts/install-selenium-server.ps1",
        "./scripts/install-chrome-firefox.ps1"
      ]
    },{
      "type": "shell",
      "remote_path": "/tmp/script.bat",
      "execute_command": "{{.Vars}} cmd /c C:/Windows/Temp/script.bat",
      "scripts": [
        "./scripts/vm-guest-tools.bat",
        "./scripts/vagrant-ssh.bat",
        "./scripts/rsync.bat",
        "./scripts/enable-rdp.bat"
      ]
    }
  ],
    "post-processors": [
    {
      "type": "vagrant",
      "keep_input_artifact": false,
      "output": "{{user `vm_name`}}_{{.Provider}}.box",
      "vagrantfile_template": "vagrantfile-template"
    }
    ]
}</pre>
      </td>
    </tr>
  </table>
</div>

#### Additional Software

This is not done here. Obviously, in order to test your stuff, you first need to install your software on this box. Ideally, everything you need should be in the code you clone to this box, and should be contained mostly. And your application deployment should take core of that. But, if you require something like a DB, postgres, oracle, whatnot, than this is the place where you would install all that. 

# Vagrant and Using the Packer Box

Now, this has been interesting so far, but how do you actually go about using this image? That&#8217;s the real question now, isn&#8217;t it? Having a box, just sitting on a shared folder, doesn&#8217;t do you too much good. So let&#8217;s create a Jenkins job, which utilizes this box in a job which runs a bunch of tests for some application.

#### Vagrantfile

Your vagrant file, could either be generated automatically, under source control ( which is preferred ) or sitting somewhere entirely elsewhere. In any case, it would look something like this.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="ruby" style="font-family:monospace;"><span style="color:#008000; font-style:italic;"># -*- mode: ruby -*-</span>
<span style="color:#008000; font-style:italic;"># vi: set ft=ruby :</span>
&nbsp;
VAGRANTFILE_API_VERSION = <span style="color:#996600;">"2"</span>
&nbsp;
Vagrant.<span style="color:#9900CC;">configure</span><span style="color:#006600; font-weight:bold;">&#40;</span>VAGRANTFILE_API_VERSION<span style="color:#006600; font-weight:bold;">&#41;</span> <span style="color:#9966CC; font-weight:bold;">do</span> <span style="color:#006600; font-weight:bold;">|</span>config<span style="color:#006600; font-weight:bold;">|</span>
&nbsp;
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">provider</span> <span style="color:#996600;">"virtualbox"</span>
&nbsp;
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">define</span> <span style="color:#996600;">"selenium-box"</span> <span style="color:#9966CC; font-weight:bold;">do</span> <span style="color:#006600; font-weight:bold;">|</span>vs2013<span style="color:#006600; font-weight:bold;">|</span>
    vs2013.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">box</span> = <span style="color:#996600;">"windows7-x64-04-selenium"</span>
    vs2013.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">box_url</span> = <span style="color:#996600;">"path/to/your/share/win7x64_selenium_virtualbox.box"</span>
  <span style="color:#9966CC; font-weight:bold;">end</span>
&nbsp;
  config.<span style="color:#9900CC;">env</span>.<span style="color:#9900CC;">enable</span>
&nbsp;
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">guest</span> = <span style="color:#ff3333; font-weight:bold;">:windows</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">communicator</span> = <span style="color:#996600;">"winrm"</span>
  config.<span style="color:#9900CC;">winrm</span>.<span style="color:#9900CC;">username</span> = <span style="color:#996600;">"vagrant"</span>
  config.<span style="color:#9900CC;">winrm</span>.<span style="color:#9900CC;">password</span> = <span style="color:#996600;">"vagrant"</span>
  config.<span style="color:#9900CC;">windows</span>.<span style="color:#9900CC;">set_work_network</span> = <span style="color:#0000FF; font-weight:bold;">true</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">network</span> <span style="color:#ff3333; font-weight:bold;">:forwarded_port</span>, guest: <span style="color:#006666;">3389</span>, host: ENV<span style="color:#006600; font-weight:bold;">&#91;</span><span style="color:#996600;">'RDESKTOP_PORT'</span><span style="color:#006600; font-weight:bold;">&#93;</span>, host_ip: <span style="color:#996600;">"0.0.0.0"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">network</span> <span style="color:#ff3333; font-weight:bold;">:forwarded_port</span>, guest: <span style="color:#006666;">5985</span>, host: <span style="color:#006666;">5985</span>, id: <span style="color:#996600;">"winrm"</span>, auto_correct: <span style="color:#0000FF; font-weight:bold;">true</span>, host_ip: <span style="color:#996600;">"0.0.0.0"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">network</span> <span style="color:#ff3333; font-weight:bold;">:forwarded_port</span>, guest: <span style="color:#006666;">9991</span>, host: <span style="color:#006666;">9991</span>, id: <span style="color:#996600;">"selenium"</span>, auto_correct: <span style="color:#0000FF; font-weight:bold;">true</span>, host_ip: <span style="color:#996600;">"0.0.0.0"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">provider</span> <span style="color:#ff3333; font-weight:bold;">:virtualbox</span> <span style="color:#9966CC; font-weight:bold;">do</span> <span style="color:#006600; font-weight:bold;">|</span>vbox<span style="color:#006600; font-weight:bold;">|</span>
    vbox.<span style="color:#9900CC;">gui</span> = <span style="color:#0000FF; font-weight:bold;">false</span>
    vbox.<span style="color:#9900CC;">memory</span> = <span style="color:#006666;">4096</span>
    vbox.<span style="color:#9900CC;">cpus</span> = <span style="color:#006666;">2</span>
  <span style="color:#9966CC; font-weight:bold;">end</span>
&nbsp;
&nbsp;
  config.<span style="color:#9900CC;">winrm</span>.<span style="color:#9900CC;">max_tries</span> = <span style="color:#006666;">10</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">synced_folder</span> <span style="color:#996600;">"."</span>, <span style="color:#996600;">"/vagrant"</span>, type: <span style="color:#996600;">"rsync"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">provision</span> <span style="color:#996600;">"shell"</span>, path: <span style="color:#996600;">"init.bat"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">provision</span> <span style="color:#996600;">"shell"</span>, path: <span style="color:#996600;">"utils_inst.bat"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">provision</span> <span style="color:#996600;">"shell"</span>, path: <span style="color:#996600;">"jenkins_reg.ps1"</span>
  config.<span style="color:#9900CC;">vm</span>.<span style="color:#9900CC;">provision</span> <span style="color:#996600;">"shell"</span>, path: <span style="color:#996600;">"start_selenium.bat"</span>
<span style="color:#9966CC; font-weight:bold;">end</span></pre>
      </td>
    </tr>
  </table>
</div>

Easy, no? Here is the script to start selenium.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="batch" style="font-family:monospace;">    java -jar c:\Windows\Temp\selenium-server.jar -Dhttp.proxyPort=9991</pre>
      </td>
    </tr>
  </table>
</div>

Straight forward. We also are forwarding the port on which Selenium is running in order for the test to see it.

#### The Jenkins Job

The job can be anything. This is actually too large to cover here. It could be a gradle job, a maven job, an ant, a nant &#8211; or whatever is running the test -, job; it&#8217;s up to you. 

Just make sure that before the test runs, do a **vagrant up** and after the test finishes, in an ALWAYS TO BE EXECUTED HOOK -like gradle&#8217;s finalizedBy , call a **vagrant destroy**. This way, your test will always run on a clean instance that has the necessary stuff on it.

# Closing words

So, there you have it. It&#8217;s relatively simple. Tying this all into your infrastructure might prove difficult though depending on how rigid your deployment is. But it will always help you make your tests a bit more robust.

Also, you could run the whole deployment and test phase on a vagrant box, from the start, which is tied to jenkins as a slave and gets started when the job starts and destroyed when the job ends. That way you wouldn&#8217;t have to create a, box in a box running on a box, kind of effect.

Thanks for reading,
  
Gergely.