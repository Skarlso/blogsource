+++
author = "hannibal"
categories = ["devops", "problem solving"]
date = "2015-06-27"
type = "post"
tags = ["Packer", "vagrant", "Windows"]
title = "The Packer, The Windows, and the Vagrant box"
url = "/2015/06/27/the-packer-the-windows-and-the-vagrant-box/"

+++

Hello folks.

Today, I would like to write about something close to my heart recently. I&#8217;ve been fiddling with Packer, Windows and Vagrant these days. Trying to get a Windows box up in running is a pain in the arse though, so I thought I share my pain with you nice folks out there. Let&#8217;s begin.

<!--more-->

# Setup

First things first. You need <a href="https://packer.io/" target="_blank">Packer</a>, and <a href="https://www.vagrantup.com/" target="_blank">Vagrant</a> obviously. I&#8217;ll leave the install up to you. Next, you should clone this git repo => <a href="https://github.com/joefitzgerald/packer-windows" target="_blank">Packer Windows Plugin</a>. This plugin contains all the files necessary to get, install, and provision Windows boxes. Luckily, some very nice and clever folks, figured out a lot of things about how to install stuff on Windows. And given that people at Microsoft realised that sys admins would like to install stuff remotely, there are a bunch of forums and places where you can search for how to install software without user interaction. And this is the keyword you should look for => **unattended Windows install**.

This will lead you further into the bowls of Windows technology and silent / quiet installs all over the place.

# Packer and Answer Files

When it comes to installing software on Windows, you have quite a few obstacles to overtake. One of the biggest obstacle you are facing, are restarts. Windows has a special place in hell for that. Every time you install something important which requires system libraries or other kind of configuration which &#8220;will only take effect after you restart Windows&#8221; you have to do a restart. Now, a little background on how Packer interacts with Windows. At the moment, it uses OpenSSH to talk to the box which has to be the last which comes up. If it looses connection to openssh because, I don&#8217;t know, it restarted itself, you loose communication to the box, and the setup process stops in mid tracks.

If you read about that in an earlier attempt to overtake this, you saw that you could use time-outs. You could kill ssh process which presumably makes packer do an attempt to start a new connection. If you are like me, you experienced that Packer does indeed NOT re-try. Because the previous task couldn&#8217;t finish, the restart killed the ssh service which could tell Packer that the previous task, an install for example, has finished. Hence, Packer will stay there and wait for that task to complete; which will never happen at this point.

What can we do? Enter the world of <a href="https://technet.microsoft.com/en-us/library/cc749113(v=ws.10).aspx" target="_blank">Answer Files</a>. Basically, it&#8217;s an xml file which sets up Windows. When Packer is running this file, the last service which should be installed, must be openSSH. And after that, in the provisioning phase, you should only install software which does not require restarts.

Let&#8217;s look at an example.

# Example #1: Windows Updates

This is another layer of purgatory for Windows. It&#8217;s updates. The updates take massive amount of times, if you are doing them from scratch, and also require several restart before it&#8217;s actually done. You **could **speed up the process a little bit, if you have a private network share where all of the Windows updates are sitting. At least that way you don&#8217;t have to download them every time you are creating a box. But you can&#8217;t avert the install process itself.

Let&#8217;s look at a setup for packer. Packer works with JSON files for it&#8217;s configuration. An example for a Windows 7 box would look something like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="json" style="font-family:monospace;">{
  "builders": [
    {
      "type": "vmware-iso",
      "iso_url": "http://care.dlservice.microsoft.com/dl/download/evalx/win7/x64/EN/7600.16385.090713-1255_x64fre_enterprise_en-us_EVAL_Eval_Enterprise-GRMCENXEVAL_EN_DVD.iso",
      "iso_checksum_type": "md5",
      "iso_checksum": "1d0d239a252cb53e466d39e752b17c28",
      "headless": true,
      "boot_wait": "2m",
      "ssh_username": "vagrant",
      "ssh_password": "vagrant",
      "ssh_wait_timeout": "8h",
      "shutdown_command": "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\"",
      "guest_os_type": "windows7-64",
      "tools_upload_flavor": "windows",
      "disk_size": 61440,
      "vnc_port_min": 5900,
      "vnc_port_max": 5980,
      "floppy_files": [
        "./answer_files/7/Autounattend.xml",
        "./scripts/dis-updates.ps1",
        "./scripts/microsoft-updates.bat",
        "./scripts/win-updates.ps1",
        "./scripts/openssh.ps1"
      ],
      "vmx_data": {
        "RemoteDisplay.vnc.enabled": "false",
        "RemoteDisplay.vnc.port": "5900",
        "memsize": "2048",
        "numvcpus": "2",
        "scsi0.virtualDev": "lsisas1068"
      }
    },
    {
      "type": "virtualbox-iso",
      "iso_url": "http://care.dlservice.microsoft.com/dl/download/evalx/win7/x64/EN/7600.16385.090713-1255_x64fre_enterprise_en-us_EVAL_Eval_Enterprise-GRMCENXEVAL_EN_DVD.iso",
      "iso_checksum_type": "md5",
      "iso_checksum": "1d0d239a252cb53e466d39e752b17c28",
      "headless": true,
      "boot_wait": "2m",
      "ssh_username": "vagrant",
      "ssh_password": "vagrant",
      "ssh_wait_timeout": "8h",
      "shutdown_command": "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\"",
      "guest_os_type": "Windows7_64",
      "disk_size": 61440,
      "floppy_files": [
        "./answer_files/7/Autounattend.xml",
        "./scripts/dis-updates.ps1",
        "./scripts/microsoft-updates.bat",
        "./scripts/win-updates.ps1",
        "./scripts/openssh.ps1",
        "./scripts/oracle-cert.cer"
      ],
      "vboxmanage": [
        [
          "modifyvm",
          "{{.Name}}",
          "--memory",
          "2048"
        ],
        [
          "modifyvm",
          "{{.Name}}",
          "--cpus",
          "2"
        ]
      ]
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "remote_path": "/tmp/script.bat",
      "execute_command": "{{.Vars}} cmd /c C:/Windows/Temp/script.bat",
      "scripts": [
        "./scripts/vm-guest-tools.bat",
        "./scripts/chef.bat",
        "./scripts/vagrant-ssh.bat",
        "./scripts/disable-auto-logon.bat",
        "./scripts/enable-rdp.bat",
        "./scripts/compile-dotnet-assemblies.bat",
        "./scripts/compact.bat"
      ]
    }
  ],
  "post-processors": [
    {
      "type": "vagrant",
      "keep_input_artifact": false,
      "output": "windows_7_{{.Provider}}.box",
      "vagrantfile_template": "vagrantfile-windows_7.template"
    }
  ]
}</pre>
      </td>
    </tr>
  </table>
</div>

If it feels daunting, don&#8217;t worry. You&#8217;ll get used to it fairly quickly. Let&#8217;s go over section by section on what this does.

#### Builders

Packer uses builders for, well, building stuff. These two builders are virtualbox and vmware. I&#8217;m only interested in virtualbox. This builder downloads win7 and sets up some virtual box details like, disk size, vagrant user, memory, and so and so forth. The interesting part is the floppy part. Here, we can add in some files for setup. We will use this part later on.

#### Provisioners

Now here is an interesting tid-bit. There are a bunch of provisioners available as plugin for packer. Installing them is fairly easy. Packer needs binary plugins. Just copy them into ~/.packer.d/plugins or directly into the packer home directly. I&#8217;d advice against that. Have them in your own packer.d, that&#8217;s much cleaner. For binary plugin releases in the Windows side, look here => <a href="https://github.com/packer-community/packer-windows-plugins/releases" target="_blank">https://github.com/packer-community/packer-windows-plugins/releases</a>. If you would like to build them yourself from source, download the source and use go gcc to build it. You will have to **go get** a few packages though. Also you will have to have **$GOPATH** (pointing to your own workspace) and **$GOROOT** (pointing to your working go) setup. But this is not a Go guide. After that just do **go build main.go **and you have your plugin.

Provisioners are like vagrant provision they will execute post setup stuff on your box. Like installing utils, 7zip, choco, nuget, and so and so forth. There are a few interesting Windows provisioners, like restart-windows, powershell, and Windows shell. Which is like shell, but without the need of pre-setup if you are trying to use it on Windows. The basic shell on Windows is a little clanky and can hang from time-to-time so I recommend using PowerShell or WindowsShell provisioner if you are dealing with Windows post-setup Setup.

#### Post-Processor

This will create the Vagrant box after everything is done.

#### Running the Update

For use, two things are interesting from here at this moment. These guys =>

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="json" style="font-family:monospace;">        "./scripts/microsoft-updates.bat",
        "./scripts/win-updates.ps1",</pre>
      </td>
    </tr>
  </table>
</div>

These two contain most of the logic which is part of the update process. You should see it in your checked out source. There is some very interesting logic in there which describes how the update happens. Basically it&#8217;s a loop which re-checks if there are updates available or if a re-start is needed. Packer handles re-starts well at this point in the install because it simply waits for SSH to come only. The rest is handled by Windows.

These scripts are called in the Answer File which the Windows Setup uses for configuration purposes. Take a look at this section:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="xml" style="font-family:monospace;">                <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;SynchronousCommand</span> <span style="color: #000066;">wcm:action</span>=<span style="color: #ff0000;">"add"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;CommandLine<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>cmd.exe /c a:\microsoft-updates.bat<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/CommandLine<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;Order<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>98<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/Order<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;Description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>Enable Microsoft Updates<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/Description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/SynchronousCommand<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;SynchronousCommand</span> <span style="color: #000066;">wcm:action</span>=<span style="color: #ff0000;">"add"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;CommandLine<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\win-updates.ps1 -MaxUpdatesPerCycle 30<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/CommandLine<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;Description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>Install Windows Updates<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/Description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;Order<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>100<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/Order<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;RequiresUserInput<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>true<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/RequiresUserInput<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/SynchronousCommand<span style="color: #000000; font-weight: bold;">&gt;</span></span></span></pre>
      </td>
    </tr>
  </table>
</div>

This is were the floppy part comes on handy. This part uses the scripts bound by floppy and which will be available from a:\.

This will install all the updates available. It will take a while. A very very long while&#8230; But let&#8217;s go a step further.

# Example #2: Installing DotNet 4.5

Let&#8217;s assume you want to create a box with visual studio 2013, office, and have choco on it, and a couple of more things for which you need lots of restarts. You could try installing with /norestart switch, which also works; however if you definitely need it to restart I suggest installing stuff with the Answer File. For this, let&#8217;s create a PowerShell script which downloads and installs dotnet 451 which is needed for visual studio ultimate 2013.

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="powershell" style="font-family:monospace;"><span style="color: #800080;">$Logfile</span> <span style="color: pink;">=</span> <span style="color: #800000;">"C:\Windows\Temp\dotnet-install.log"</span>
<span style="color: #0000FF;">function</span> LogWrite <span style="color: #000000;">&#123;</span>
   <span style="color: #0000FF;">Param</span> <span style="color: #000000;">&#40;</span><span style="color: #000000;">&#91;</span><span style="color: #008080;">string</span><span style="color: #000000;">&#93;</span><span style="color: #800080;">$logstring</span><span style="color: #000000;">&#41;</span>
   <span style="color: #800080;">$now</span> <span style="color: pink;">=</span> <span style="color: #008080; font-weight: bold;">Get-Date</span> <span style="color: #008080; font-style: italic;">-format</span> s
   <span style="color: #008080; font-weight: bold;">Add-Content</span> <span style="color: #800080;">$Logfile</span> <span style="color: #008080; font-style: italic;">-value</span> <span style="color: #800000;">"$now $logstring"</span>
   <span style="color: #008080; font-weight: bold;">Write-Host</span> <span style="color: #800080;">$logstring</span>
<span style="color: #000000;">&#125;</span>
&nbsp;
LogWrite <span style="color: #800000;">"Downlading dotNetFx40_Full_x86_x64."</span>
try <span style="color: #000000;">&#123;</span>
    <span style="color: #000000;">&#40;</span><span style="color: #008080; font-weight: bold;">New-Object</span> System.Net.WebClient<span style="color: #000000;">&#41;</span>.DownloadFile<span style="color: #000000;">&#40;</span><span style="color: #800000;">'http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/NDP451-KB2858728-x86-x64-AllOS-ENU.exe'</span><span style="color: pink;">,</span> <span style="color: #800000;">'C:\Windows\Temp\dotnet.exe'</span><span style="color: #000000;">&#41;</span>
<span style="color: #000000;">&#125;</span> catch <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #000080;">$_</span>.Exception <span style="color: pink;">|</span> <span style="color: #008080; font-weight: bold;">Format-List</span> <span style="color: #008080; font-style: italic;">-force</span>
    LogWrite <span style="color: #800000;">"Failed to download file."</span>
<span style="color: #000000;">&#125;</span>
&nbsp;
LogWrite <span style="color: #800000;">"Starting installation process..."</span>
try <span style="color: #000000;">&#123;</span>
    Start<span style="color: pink;">-</span>Process <span style="color: #008080; font-style: italic;">-FilePath</span> <span style="color: #800000;">"C:\Windows\Temp\dotnet.exe"</span> <span style="color: #008080; font-style: italic;">-ArgumentList</span> <span style="color: #800000;">"/I /q /norestart"</span> <span style="color: #008080; font-style: italic;">-Wait</span> <span style="color: #008080; font-style: italic;">-PassThru</span>
<span style="color: #000000;">&#125;</span> catch <span style="color: #000000;">&#123;</span>
    LogWrite <span style="color: #000080;">$_</span>.Exception <span style="color: pink;">|</span> <span style="color: #008080; font-weight: bold;">Format-List</span> <span style="color: #008080; font-style: italic;">-force</span>
    LogWrite <span style="color: #800000;">"Exception during install process."</span>    
<span style="color: #000000;">&#125;</span></pre>
      </td>
    </tr>
  </table>
</div>

So this downloads it right from the source. As mentioned earlier, you could have this on a nice shared drive so downloading from the internet is not necessary. The installer is in fact a bit friendly. It has a switch called /q /norestart. The /q is called silent install and the /norestart speaks for itself. If you leave it out, you can use /forcerestart or you could have the following two lines after this finishes: _LogWrite &#8220;Resarting Computer.&#8221; Restart-Computer -Force_. This will force a restart. You need the -Force because otherwise it won&#8217;t let it restart while there are active sessions logged on the computer.

Now, let&#8217;s add this to the answer file:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="xml" style="font-family:monospace;">                <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;SynchronousCommand</span> <span style="color: #000066;">wcm:action</span>=<span style="color: #ff0000;">"add"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;CommandLine<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>cmd.exe /c C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\install-dotnet-451.ps1 -AutoStart<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/CommandLine<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;Order<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>98<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/Order<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                    <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;Description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>Install DotNet 4.5.1.<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/Description<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
                <span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/SynchronousCommand<span style="color: #000000; font-weight: bold;">&gt;</span></span></span></pre>
      </td>
    </tr>
  </table>
</div>

See, how easy this is? And now we make use of the floppy part of the windows-7.json by adding this line: **&#8220;./scripts/install-dotnet-451.ps1&#8221;**. Don&#8217;t forget to append the &#8220;,&#8221; at the end of the previous line. This is an array.

We are ready to go. Just run **packer build -only=virtualbox-iso windows-7.json** and you should be done!

# Example #3: Installing Visual Studio Ultimate

Installing visual studio is almost trivial as well. With the addition that visual studio requires an admin.xml for silent install which has a bunch of settings. When you have the admin.xml just bind it into the floppy drive as well and call the visual studio install powershell script like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="powershell" style="font-family:monospace;">    Start<span style="color: pink;">-</span>Process <span style="color: #008080; font-style: italic;">-FilePath</span> <span style="color: #800000;">"C:\Windows\Temp\visualstudioultimate.exe"</span> <span style="color: #008080; font-style: italic;">-ArgumentList</span> <span style="color: #800000;">"/Quiet /NoRestart /admin a:\admin.xml"</span> <span style="color: #008080; font-style: italic;">-Wait</span> <span style="color: #008080; font-style: italic;">-PassThru</span></pre>
      </td>
    </tr>
  </table>
</div>

Again, this will take a while&#8230;&#8230;&#8230;&#8230;.

# Post Setup Provisioning

When all this is done, you can still add some provisioning steps to add some utils with PowerShell or WindowsShell provisioner. I would advice against using simple shell. Bare in mind one other thing. If you have a batch file, and you are calling another batch file in that batch file, like choco install 7zip, it will happen that the install process will hang on installing 7zip. Because in Windows land the called script will not return the exec handler to the caller unless specifically asking for it with **call**. Which means your bat file will look something like this:

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="batch" style="font-family:monospace;">call choco install 7zip
call choco install notepadplusplus</pre>
      </td>
    </tr>
  </table>
</div>

or

<div class="wp_syntax">
  <table>
    <tr>
      <td class="code">
        <pre class="batch" style="font-family:monospace;">cmd /c choco install 7zip
cmd /c choco install notepadplusplus</pre>
      </td>
    </tr>
  </table>
</div>

And so on, and so forth. 

# Wrap-Up

So, what have we learned? We have learned that installing software which requires re-start is better left to Windows itself with an answer file. Batch files will not return the handler. SSH **MUST** be the last thing you start up in the answer file. Use PowerShell provisioner or WindowsShell provisioner on Windows. 

Hope this helped.
  
Happy installing, and as always,
  
Thanks for reading.
  
Gergely.