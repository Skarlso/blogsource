+++
author = "hannibal"
categories = ["devops", "problem solving"]
date = "2015-06-30"
type = "post"
tags = ["powershell", "unattended", "Windows"]
title = "Powershell can also be nice -Or Installing Java silently and waiting"
url = "/2015/06/30/powershell-can-also-be-nice-or-installing-java-silently-and-waiting/"

+++

Hello folks.

Today, I would like to show you a small script. It installs Java JDK, both version, x86 and 64 bit, silently, and wait for that process to finish. 

The wait is necessary because /s on a java install has the nasty habit of running in the background. If you are using a .bat file, **you shouldn&#8217;t**, than you would use something like: start /w jdk-setup.exe /s. This gets it done, but is ugly. Also, if you are using Packer and PowerShell provisioning, you might want to set up some environment variables as well for the next script. And you want that property to be available and you don&#8217;t want to mess it up with setting a path into a file and then re-setting your path on the begin of your other script. Or pass it around with Packer. No. Use a proper PowerShell script. Learn it. It&#8217;s not that hard. Be a professional. Don&#8217;t hack something together for the next person to suffer at. 

Here is how I did it. Hope it helps somebody out.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="powershell" style="font-family:monospace;"><span style="color: #800080;">$JDK_VER</span><span style="color: pink;">=</span><span style="color: #800000;">"7u75"</span>
<span style="color: #800080;">$JDK_FULL_VER</span><span style="color: pink;">=</span><span style="color: #800000;">"7u75-b13"</span>
<span style="color: #800080;">$JDK_PATH</span><span style="color: pink;">=</span><span style="color: #800000;">"1.7.0_75"</span>
<span style="color: #800080;">$source86</span> <span style="color: pink;">=</span> <span style="color: #800000;">"http://download.oracle.com/otn-pub/java/jdk/$JDK_FULL_VER/jdk-$JDK_VER-windows-i586.exe"</span>
<span style="color: #800080;">$source64</span> <span style="color: pink;">=</span> <span style="color: #800000;">"http://download.oracle.com/otn-pub/java/jdk/$JDK_FULL_VER/jdk-$JDK_VER-windows-x64.exe"</span>
<span style="color: #800080;">$destination86</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\vagrant\$JDK_VER-x86.exe"</span>
<span style="color: #800080;">$destination64</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\vagrant\$JDK_VER-x64.exe"</span>
<span style="color: #800080;">$client</span> <span style="color: pink;">=</span> <span style="color: #008080; font-weight: bold;">new-object</span> System.Net.WebClient
<span style="color: #800080;">$cookie</span> <span style="color: pink;">=</span> <span style="color: #800000;">"oraclelicense=accept-securebackup-cookie"</span>
<span style="color: #800080;">$client</span>.Headers.Add<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#91;</span>System.Net.HttpRequestHeader<span style="color: #000000;">&#93;</span>::Cookie<span style="color: pink;">,</span> <span style="color: #800080;">$cookie</span><span style="color: #000000;">&#41;</span>
&nbsp;
<span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Checking if Java is already installed'</span>
<span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800000;">"c:\Program Files (x86)\Java"</span><span style="color: #000000;">&#41;</span> <span style="color: #FF0000;">-Or</span> <span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800000;">"c:\Program Files\Java"</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
    <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'No need to Install Java'</span>
    Exit
<span style="color: #000000;">&#125;</span>
&nbsp;
<span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Downloading x86 to $destination86'</span>
&nbsp;
<span style="color: #800080;">$client</span>.downloadFile<span style="color: #000000;">&#40;</span><span style="color: #800080;">$source86</span><span style="color: pink;">,</span> <span style="color: #800080;">$destination86</span><span style="color: #000000;">&#41;</span>
<span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: pink;">!</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800080;">$destination86</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
    <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">"Downloading $destination86 failed"</span>
    Exit
<span style="color: #000000;">&#125;</span>
<span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Downloading x64 to $destination64'</span>
&nbsp;
<span style="color: #800080;">$client</span>.downloadFile<span style="color: #000000;">&#40;</span><span style="color: #800080;">$source64</span><span style="color: pink;">,</span> <span style="color: #800080;">$destination64</span><span style="color: #000000;">&#41;</span>
<span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: pink;">!</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800080;">$destination64</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
    <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">"Downloading $destination64 failed"</span>
    Exit
<span style="color: #000000;">&#125;</span>
&nbsp;
&nbsp;
try <span style="color: #000000;">&#123;</span>
    <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Installing JDK-x64'</span>
    <span style="color: #800080;">$proc1</span> <span style="color: pink;">=</span> Start<span style="color: pink;">-</span>Process <span style="color: #008080; font-style: italic;">-FilePath</span> <span style="color: #800000;">"$destination64"</span> <span style="color: #008080; font-style: italic;">-ArgumentList</span> <span style="color: #800000;">"/s REBOOT=ReallySuppress"</span> <span style="color: #008080; font-style: italic;">-Wait</span> <span style="color: #008080; font-style: italic;">-PassThru</span>
    <span style="color: #800080;">$proc1</span>.waitForExit<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#41;</span>
    <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Installation Done.'</span>
&nbsp;
    <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Installing JDK-x86'</span>
    <span style="color: #800080;">$proc2</span> <span style="color: pink;">=</span> Start<span style="color: pink;">-</span>Process <span style="color: #008080; font-style: italic;">-FilePath</span> <span style="color: #800000;">"$destination86"</span> <span style="color: #008080; font-style: italic;">-ArgumentList</span> <span style="color: #800000;">"/s REBOOT=ReallySuppress"</span> <span style="color: #008080; font-style: italic;">-Wait</span> <span style="color: #008080; font-style: italic;">-PassThru</span>
    <span style="color: #800080;">$proc2</span>.waitForExit<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#41;</span>
    <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Installtion Done.'</span>
<span style="color: #000000;">&#125;</span> catch <span style="color: #000000;">&#91;</span>exception<span style="color: #000000;">&#93;</span> <span style="color: #000000;">&#123;</span>
    <span style="color: #008080; font-weight: bold;">write-host</span> <span style="color: #800000;">'$_ is'</span> <span style="color: #000080;">$_</span>
    <span style="color: #008080; font-weight: bold;">write-host</span> <span style="color: #800000;">'$_.GetType().FullName is'</span> <span style="color: #000080;">$_</span>.GetType<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#41;</span>.FullName
    <span style="color: #008080; font-weight: bold;">write-host</span> <span style="color: #800000;">'$_.Exception is'</span> <span style="color: #000080;">$_</span>.Exception
    <span style="color: #008080; font-weight: bold;">write-host</span> <span style="color: #800000;">'$_.Exception.GetType().FullName is'</span> <span style="color: #000080;">$_</span>.Exception.GetType<span style="color: #000000;">&#40;</span><span style="color: #000000;">&#41;</span>.FullName
    <span style="color: #008080; font-weight: bold;">write-host</span> <span style="color: #800000;">'$_.Exception.Message is'</span> <span style="color: #000080;">$_</span>.Exception.Message
<span style="color: #000000;">&#125;</span>
&nbsp;
<span style="color: #0000FF;">if</span> <span style="color: #000000;">&#40;</span><span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800000;">"c:\Program Files (x86)\Java"</span><span style="color: #000000;">&#41;</span> <span style="color: #FF0000;">-Or</span> <span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">Test-Path</span> <span style="color: #800000;">"c:\Program Files\Java"</span><span style="color: #000000;">&#41;</span><span style="color: #000000;">&#41;</span> <span style="color: #000000;">&#123;</span>
    <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Java installed successfully.'</span>
<span style="color: #000000;">&#125;</span>
<span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Setting up Path variables.'</span>
<span style="color: #000000;">&#91;</span>System.Environment<span style="color: #000000;">&#93;</span>::SetEnvironmentVariable<span style="color: #000000;">&#40;</span><span style="color: #800000;">"JAVA_HOME"</span><span style="color: pink;">,</span> <span style="color: #800000;">"c:\Program Files (x86)\Java\jdk$JDK_PATH"</span><span style="color: pink;">,</span> <span style="color: #800000;">"Machine"</span><span style="color: #000000;">&#41;</span>
<span style="color: #000000;">&#91;</span>System.Environment<span style="color: #000000;">&#93;</span>::SetEnvironmentVariable<span style="color: #000000;">&#40;</span><span style="color: #800000;">"PATH"</span><span style="color: pink;">,</span> <span style="color: #800080;">$Env</span>:Path <span style="color: pink;">+</span> <span style="color: #800000;">";c:\Program Files (x86)\Java\jdk$JDK_PATH\bin"</span><span style="color: pink;">,</span> <span style="color: #800000;">"Machine"</span><span style="color: #000000;">&#41;</span>
<span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800000;">'Done. Goodbye.'</span></pre>
      </td>
    </tr>
  </table>
</div>

Now, there is room for improvement here. Like checking exit code, doing something extra after a failed exit. Throwing an exception, and so on and so forth. But this is a much needed improvement from calling a BAT file. 

And you would use this in a Packer JSON file like this..

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="json" style="font-family:monospace;">{
      "type": "powershell",
      "scripts": [
        "./scripts/jdk_inst.ps1"
      ]
}</pre>
      </td>
    </tr>
  </table>
</div>

Easy. And at the end, the System.Environment actually writes out into the registry permanently so no need to pass it around in a file or something ugly like that.

Hope this helps somebody.
  
Thanks for reading.
  
Gergely.