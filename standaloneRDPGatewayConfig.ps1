[string]$hostname = $args[0]

function check-servercertificate($ServerToCheck)
{
    $timeoutMilliseconds = 9000
    $url = "https://$ServerToCheck"
    #disabling the cert validation check.
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
    #Create request
    $req = [Net.HttpWebRequest]::Create($url)
    $req.Timeout = $timeoutMilliseconds
    try {$req.GetResponse() |Out-Null} catch 
    {
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
        return "error"
    }
    $certThumbprint = $req.ServicePoint.Certificate.GetCertHashString()
    [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
    return $certThumbprint 
}

$RegistryLocation = "HKLM:\Software\CloudDesktop"


#We will first check if this is the first time the script runs
if ((Get-ItemProperty -Path $RegistryLocation -Name FirstRun -ErrorAction SilentlyContinue).firstrun)
{$firstrun=$false}
else
{
    mkdir $RegistryLocation
    Set-ItemProperty -Path $RegistryLocation -Name FirstRun -Value "done"
    $firstrun=$true
}

if ($hostname.Length -gt 0) {Set-ItemProperty -Path $RegistryLocation -Name hostname -Value $hostname} else {$hostname = (Get-ItemProperty -Path $RegistryLocation -Name hostname -ErrorAction SilentlyContinue).hostname}
#$cpelsSerial = (Get-ItemProperty -Path $RegistryLocation -Name cpelsSerial -ErrorAction SilentlyContinue).cpelsSerial
#if($cpelsSerial) {write-host "serial found"} else {$cpelsSerial =  ""}

#Download this script for running everytime on system startup
if ((Test-Path "c:\support") -eq $false){mkdir "c:\support"}
$destination = "c:\support\standaloneRDPGatewayConfig.ps1"
if ((Test-Path $destination) -eq $false)
{
	$source = "https://raw.githubusercontent.com/CharlPels/CloudDesktop/master/standaloneRDPGatewayConfig.ps1"
	Invoke-WebRequest $source -OutFile $destination	-ContentType text/plain
}
$destination = "c:\support\updateserverServeronStartup.xml"
if ((Test-Path $destination) -eq $false)
{
	$source = "https://raw.githubusercontent.com/CharlPels/CloudDesktop/master/updateserverServeronStartup.xml"
	$destination = "c:\support\updateserverServeronStartup.xml"
	Invoke-WebRequest $source -OutFile $destination	-ContentType text/plain
    #Create Schedulet task
    schtasks.exe /create /RU system /TN updateserverServeronStartup /XML c:\support\updateserverServeronStartup.xml
}
$destination = "c:\support\letsencrypt-win-simple.V1.9.3.zip"
if ((Test-Path $destination) -eq $false)
{
	$source = "https://mydesktopfunction.blob.core.windows.net/deploymentscript/letsencrypt-win-simple.V1.9.3.zip"
	$destination = "c:\support\letsencrypt-win-simple.V1.9.3.zip"
	Invoke-WebRequest $source -OutFile $destination	#-ContentType text/plain
	#unzip the file
	$shell_app=new-object -com shell.application
	$filename = $destination
	$zip_file = $shell_app.namespace($destination)
	$destination = $shell_app.namespace("c:\support")
	$destination.Copyhere($zip_file.items())
}



if ((Get-WindowsFeature -Name RDS-Gateway).installed -eq $false) 
{
	Add-WindowsFeature -Name RDS-Gateway, RDS-Web-Access, rsat-ad-powershell -IncludeAllSubFeature -IncludeManagementTools -Restart
}
Import-Module remotedesktopservices

#Code to run only onetime
if ($firstrun -eq $false)
{
    #create folders and copy webconfig
    if ((test-path C:\inetpub\wwwroot\.well-known) -eq $false) { mkdir C:\inetpub\wwwroot\.well-known }
    copy C:\support\Web_Config.xml C:\inetpub\wwwroot\.well-known\Web.Config
    
 
    #Time to configure iis host header and get a certificate
    new-webbinding -hostheader $HostName -name "Default Web Site" -protocol http
    #request a lets encrypt cert
    #Source and credits go to https://github.com/Lone-Coder/letsencrypt-win-simple/releases
    C:\support\letsencrypt --signeremail $cpelsEmail --accepttos --emailaddress $cpelsEmail --usedefaulttaskuser --baseuri "https://acme-v01.api.letsencrypt.org/" --manualhost $HostName --webroot "%SystemDrive%\inetpub\wwwroot" --centralsslstore C:\support
    $certfile = "C:\support\" + $HostName + ".pfx"
    $importedcert = Import-PfxCertificate -FilePath $certfile cert:\localMachine\my -Confirm:$false

    #Set the new thumprint
    Set-Item -Path RDS:\GatewayServer\SSLCertificate\Thumbprint -Value $importedcert.Thumbprint

    #Disable rdp channel binding
    new-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\TerminalServerGateway\Config\Core" -Name EnforceChannelBinding -Value 0
 
    #Configure RDP website
    Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='PasswordChangeEnabled']" -name value -Value "true"
    Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='GatewayCredentialsSource']" -name value -Value "0"
    Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\" -filter "/appSettings/add[@key='WorkspaceName']" -name value -Value "My workplace in the cloud"

    #Cleanup existing RAP and CAP entries
    #get-item -Path "RDS:\GatewayServer\RAP\*" | remove-item -Recurse -Force -Confirm:$false
    #get-item -Path "RDS:\GatewayServer\cap\*" | remove-item -Recurse -Force -Confirm:$false

    #Configure RDP Gateway RAP and CAP entries
    New-Item -Path "RDS:\GatewayServer\cap" -Name FullAccess -UserGroups "administrators@BUILTIN" -AuthMethod 1
    New-Item -Path "RDS:\GatewayServer\RAP" -Name FullAccess -UserGroups "administrators@BUILTIN" -ComputerGroupType 2
    set-Item -Path "RDS:\GatewayServer\rap\FullAccess\PortNumbers" -Value *
	
	#Alter iis start page
	#C:\inetpub\wwwroot\iisstart.htm
	$source = "https://raw.githubusercontent.com/CharlPels/CloudDesktop/master/iisstart.htm"
	Invoke-WebRequest $source -OutFile "C:\inetpub\wwwroot\iisstart.htm"
	
	Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='DefaultTSGateway']" -name value -Value "$HostName"

    Restart-Computer -Force
	break
}

#Configure RDP website
Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='DefaultTSGateway']" -name value -Value "$HostName"
$certfile = "C:\support\" + $HostName + ".pfx"
$importedcert = Import-PfxCertificate -FilePath $certfile cert:\localMachine\my -Confirm:$false

if ((get-Item -Path RDS:\GatewayServer\SSLCertificate\Thumbprint).CurrentValue -ne (check-servercertificate -ServerToCheck localhost))
{

	Set-Item -Path RDS:\GatewayServer\SSLCertificate\Thumbprint -Value $importedcert.Thumbprint
	sleep 5
	#Restart Services
	#we restart the webserver every day, this is not the main goal but solve the installation issue
	#where the gateway is not picking up the new settings
	write-host "Restart Services"
	Restart-Service "W3SVC" -Force
	Restart-Service "remote desktop gateway" -Force
}
