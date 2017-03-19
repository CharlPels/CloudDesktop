[string]$cpelsEmail = $args[0]

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

#Get Server public IP
#$getIP = (Invoke-RestMethod -Method "get" -Uri "localhost/backend/api/v1.0/get-pubip" -ContentType application/json).ip

#We will first check if this is the first time the script runs
if ((Get-ItemProperty -Path $RegistryLocation -Name FirstRun -ErrorAction SilentlyContinue).firstrun)
{$firstrun=$false}
else
{
	mkdir $RegistryLocation
    #if script runs manualy we ask for the email address we need to send the connaection information to
	if ($cpelsEmail.Length -eq 0) {$cpelsEmail = Read-Host 'What is your email address?'} else {sleep 60}
    Set-ItemProperty -Path $RegistryLocation -Name FirstRun -Value "done"
    $firstrun=$true
}

if ($cpelsEmail.Length -gt 0 -and $cpelsEmail -ne "-Confirm:") {Set-ItemProperty -Path $RegistryLocation -Name cpelsEmail -Value $cpelsEmail} else {$cpelsEmail = (Get-ItemProperty -Path $RegistryLocation -Name cpelsEmail -ErrorAction SilentlyContinue).cpelsEmail}
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


#The request we send to the API for certificate and DNS updates
$body = @{
    'Email'= $cpelsEmail
}

ConvertTo-Json $body
try{
$response = Invoke-RestMethod -Method "post" -Uri "https://mydesktopfunction.azurewebsites.net/mydesktop/api/v1.0/createupdatedns" -Body (ConvertTo-Json $body) -ContentType application/json

$response = ConvertFrom-Json $response
}
catch
{write-host "error in communication"
break}

$source = $response.keysource
$certdestination = "c:\support\key.p12"
Invoke-WebRequest $source -OutFile $certdestination
$mypwd = ConvertTo-SecureString -String $response.keypass -Force –AsPlainText
try{
$Thumbprint = Import-PfxCertificate –FilePath $certdestination cert:\localMachine\my -Password $mypwd -Confirm:$false
}
catch {
#We need to break if certifacte instalation fails
write-host "certificate import error"
break}


$HostName = $response.DNSName
if ((Test-Path $certdestination) -eq $TRUE) {rm $certdestination -Force}
#Set-ItemProperty -Path $RegistryLocation -Name cpelsSerial -Value $response.info.serial
    


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
    #get-item -Path "RDS:\GatewayServer\RAP\*" | remove-item -Recurse -Force -Confirm:$false
    #get-item -Path "RDS:\GatewayServer\cap\*" | remove-item -Recurse -Force -Confirm:$false

    #Configure RDP Gateway RAP and CAP entries
    New-Item -Path "RDS:\GatewayServer\cap" -Name FullAccess -UserGroups "administrators@BUILTIN" -AuthMethod 1
    New-Item -Path "RDS:\GatewayServer\RAP" -Name FullAccess -UserGroups "administrators@BUILTIN" -ComputerGroupType 2
    set-Item -Path "RDS:\GatewayServer\rap\FullAccess\PortNumbers" -Value *
	
	#Alter iis start page
	#C:\inetpub\wwwroot\iisstart.htm
	$source = "https://mydesktop-api.cpels.com/static/mydesktop-support/iisstart.htm"
	Invoke-WebRequest $source -OutFile "C:\inetpub\wwwroot\iisstart.htm"
	
	Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='DefaultTSGateway']" -name value -Value "$HostName"

    Restart-Computer -Force
	break
}

#Configure RDP website
Set-WebConfigurationProperty -pspath "iis:\Sites\Default Web Site\RDWeb\Pages" -filter "/appSettings/add[@key='DefaultTSGateway']" -name value -Value "$HostName"

Set-Item -Path RDS:\GatewayServer\SSLCertificate\Thumbprint -Value $Thumbprint.Thumbprint
sleep 5
#Restart Services
#we restart the webserver every day, this is not the main goal but solve the installation issue
#where the gateway is not picking up the new settings
write-host "Restart Services"
Restart-Service "W3SVC" -Force
Restart-Service "remote desktop gateway" -Force

#Life is not perfect and certificate installation will fail sometimes that is what we check the actual server certificate to make shure all is oke
if ((check-servercertificate -ServerToCheck localhost) -ne $Thumbprint.Thumbprint)
{
write-host "Stopping the gateway and webserver"
Stop-Service "W3SVC" -Force
Stop-Service "remote desktop gateway" -Force

Set-Item -Path RDS:\GatewayServer\SSLCertificate\Thumbprint -Value $Thumbprint.Thumbprint

#Restart Services
#write-host "Restart Services"
#Restart-Service "W3SVC" -Force
#Restart-Service "remote desktop gateway" -Force

Restart-Computer -Force


} else {write-host "All oke now"}
