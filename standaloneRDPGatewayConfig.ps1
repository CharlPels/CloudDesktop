[string]$cpelsEmail = $args[0]


$RegistryLocation = "HKLM:\Software\CloudDesktop"

#Get Server public IP
#$getIP = (Invoke-RestMethod -Method "get" -Uri "localhost/backend/api/v1.0/get-pubip" -ContentType application/json).ip
if ((Get-ItemProperty -Path $RegistryLocation -Name FirstRun -ErrorAction SilentlyContinue).firstrun)
{$firstrun=$false}
else
{
	mkdir $RegistryLocation
	if ($cpelsEmail.Length -eq 0) {$cpelsEmail = Read-Host 'What is your email address?'} else {sleep 60}
    Set-ItemProperty -Path $RegistryLocation -Name FirstRun -Value "done"
    $firstrun=$true
}

if ($cpelsEmail.Length -gt 0 -and $cpelsEmail -ne "-Confirm:") {Set-ItemProperty -Path $RegistryLocation -Name cpelsEmail -Value $cpelsEmail} else {$cpelsEmail = (Get-ItemProperty -Path $RegistryLocation -Name cpelsEmail -ErrorAction SilentlyContinue).cpelsEmail}
$cpelsSerial = (Get-ItemProperty -Path $RegistryLocation -Name cpelsSerial -ErrorAction SilentlyContinue).cpelsSerial
if($cpelsSerial) {write-host "serial found"} else {$cpelsSerial =  ""}

#Download this script for running everytime on system startup
if ((Test-Path "c:\support") -eq $false){mkdir "c:\support"}
$destination = "c:\support\standaloneRDPGatewayConfig.ps1"
if ((Test-Path $destination) -eq $false)
{
	$source = "https://raw.githubusercontent.com/CharlPels/CloudDesktop/master/standaloneRDPGatewayConfig.ps1"
	Invoke-WebRequest $source -OutFile $destination
}
$destination = "c:\support\updateserverServeronStartup.xml"
if ((Test-Path $destination) -eq $false)
{
	$source = "https://raw.githubusercontent.com/CharlPels/CloudDesktop/master/updateserverServeronStartup.xml"
	$destination = "c:\support\updateserverServeronStartup.xml"
	Invoke-WebRequest $source -OutFile $destination	
    #Create Schedulet task
    schtasks.exe /create /RU system /TN updateserverServeronStartup /XML c:\support\updateserverServeronStartup.xml
}


$body = @{
    'email'= $cpelsEmail
    'serial'= $cpelsSerial
}

ConvertTo-Json $body
$response = Invoke-RestMethod -Method "post" -Uri "https://mydesktop-api.cpels.com/mydesktop/api/v1.0/createupdatedns" -Body (ConvertTo-Json $body) -ContentType application/json

$source = $response.info.keysource
$certdestination = "c:\support\key.p12"
Invoke-WebRequest $source -OutFile $certdestination
$mypwd = ConvertTo-SecureString -String $response.info.keypass -Force -AsPlainText 
$Thumbprint = Import-PfxCertificate –FilePath $certdestination cert:\localMachine\my -Password $mypwd -Confirm:$false

$HostName = $response.info.dnsname
if ((Test-Path $certdestination) -eq $TRUE) {rm $certdestination -Force}
Set-ItemProperty -Path $RegistryLocation -Name cpelsSerial -Value $response.info.serial
    

###############################################
#Check to see script has administrator access
###############################################
#http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/09/23/a-self-elevating-powershell-script.aspx
# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   # Exit from the current, unelevated, process
   exit
   }
 
# Run your code that needs to be elevated here




if ((Get-WindowsFeature -Name RDS-Gateway).installed -eq $false) 
{
	Add-WindowsFeature -Name RDS-Gateway, RDS-Web-Access, rsat-ad-powershell -IncludeAllSubFeature -IncludeManagementTools -Restart
}
Import-Module remotedesktopservices

if (((Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\TerminalServerGateway\Config\Core" -Name EnforceChannelBinding).EnforceChannelBinding) -ne 0)
{
    
    Set-Item -Path RDS:\GatewayServer\SSLCertificate\Thumbprint -Value $Thumbprint.Thumbprint

    #Disable rdp channel binding
    new-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\TerminalServerGateway\Config\Core" -Name EnforceChannelBinding -Value 0
 
    #Configure RDP website
    Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='PasswordChangeEnabled']" -name value -Value "true"
    Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='GatewayCredentialsSource']" -name value -Value "0"
    Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\" -filter "/appSettings/add[@key='WorkspaceName']" -name value -Value "My workplace in the cloud"

    #Cleanup existing RAP and CAP entries
    get-item -Path "RDS:\GatewayServer\RAP\*" | remove-item -Recurse -Force -Confirm:$false
    get-item -Path "RDS:\GatewayServer\cap\*" | remove-item -Recurse -Force -Confirm:$false

    #Configure RDP Gateway RAP and CAP entries
    New-Item -Path "RDS:\GatewayServer\cap" -Name FullAccess -UserGroups "administrators@BUILTIN" -AuthMethod 1
    New-Item -Path "RDS:\GatewayServer\RAP" -Name FullAccess -UserGroups "administrators@BUILTIN" -ComputerGroupType 2
    set-Item -Path "RDS:\GatewayServer\rap\FullAccess\PortNumbers" -Value *
	
	#Alter iis start page
	#C:\inetpub\wwwroot\iisstart.htm
	$source = "https://mydesktop-api.cpels.com/static/mydesktop-support/iisstart.htm"
	Invoke-WebRequest $source -OutFile "C:\inetpub\wwwroot\iisstart.htm"
	
	Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='DefaultTSGateway']" -name value -Value "$HostName"

	
	#Disable-IEESC
	#sleep 50
	
}




if ($Thumbprint.Thumbprint -notlike (get-Item -Path RDS:\GatewayServer\SSLCertificate\Thumbprint).CurrentValue)
{
    Set-Item -Path RDS:\GatewayServer\SSLCertificate\Thumbprint -Value $Thumbprint.Thumbprint
	#Configure RDP website
	Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='DefaultTSGateway']" -name value -Value "$HostName"

	#Restart Services
    if ($firstrun -eq $false)
    {
	    Restart-Service "W3SVC" -Force
	    Restart-Service "remote desktop gateway"
    }
    else
    {
        Restart-Computer -Force
    }
}

