#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

$subNetName1 = "RDPGatewaySubnet"
$CloudNetwork = "RDPGatewayNetwork"
$ResourceGroupName = "MyCloud"
$location = "West Europe"
#$adminUser = "Charl"
#$password = "Welkom123"

$cpelsService = New-WebServiceProxy -Uri http://myclouddesktop.azurewebsites.net/Service1.svc?wsdl

#Sample function that provides the location of the script
function Get-ScriptDirectory
{
	[OutputType([string])]
	param ()
	if ($hostinvocation -ne $null)
	{
		Split-Path $hostinvocation.MyCommand.path
	}
	else
	{
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}



#Source: http://hackandflail.blogspot.nl/2010/08/powershell-open-file-dialog.html
Function Get-SaveRdpFile($initialDirectory)
{
	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
	Out-Null
	
	$SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
	$SaveFileDialog.initialDirectory = $initialDirectory
	$SaveFileDialog.filter = "All files (*.rdp)| *.rdp"
	$SaveFileDialog.ShowDialog() | Out-Null
	$SaveFileDialog.filename
}

function Sleep-tillWebsiteIsUp($url)
{
	Write-Host "URL to test: $url"
	do
	{
		# First we create the request.
		$HTTP_Request = [System.Net.WebRequest]::Create($url)
		# We then get a response from the site.
		$HTTP_Response = $HTTP_Request.GetResponse()
		# We then get the HTTP code as an integer.
		$HTTP_Status = [int]$HTTP_Response.StatusCode
		sleep 10
		#Write-Host -ForegroundColor Yellow "Your server is not online yet, status: $HTTP_Status"
		#$messages.AppendText("Your server is not online yet, status: $HTTP_Status")
		if ($HTTP_Status -ne 200) { Update-MessageStatus -newmessage "Your server is not online yet, status: $HTTP_Status" }
		
	}
	while ($HTTP_Status -ne 200)
	Update-MessageStatus -newmessage "Your server is ready for use"
}

function Update-MessageStatus($newmessage)
{
	#Dim datetime As DateTime = Date.Now
	$newmessage = $newmessage + "`n"
	$messages.AppendText($newmessage)
	#$messages.Select(status.TextLength, 0)
	$messages.ScrollToCaret()
	
}

#Function Source: https://blogs.blackmarble.co.uk/blogs/rhepworth/post/2014/03/04/Creating-Azure-Virtual-Networks-using-Powershell-and-XML-Part-2-Powershell-functions.aspx
function get-azureNetworkXml
{
	$currentVNetConfig = get-AzureVNetConfig
	if ($currentVNetConfig -ne $null)
	{
		[xml]$workingVnetConfig = $currentVNetConfig.XMLConfiguration
	}
	else
	{
		$workingVnetConfig = new-object xml
	}
	
	$networkConfiguration = $workingVnetConfig.GetElementsByTagName("NetworkConfiguration")
	if ($networkConfiguration.count -eq 0)
	{
		$newNetworkConfiguration = create-newXmlNode -nodeName "NetworkConfiguration"
		$newNetworkConfiguration.SetAttribute("xmlns:xsd", "http://www.w3.org/2001/XMLSchema")
		$newNetworkConfiguration.SetAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance")
		$networkConfiguration = $workingVnetConfig.AppendChild($newNetworkConfiguration)
	}
	
	$virtualNetworkConfiguration = $networkConfiguration.GetElementsByTagName("VirtualNetworkConfiguration")
	if ($virtualNetworkConfiguration.count -eq 0)
	{
		$newVirtualNetworkConfiguration = create-newXmlNode -nodeName "VirtualNetworkConfiguration"
		$virtualNetworkConfiguration = $networkConfiguration.AppendChild($newVirtualNetworkConfiguration)
	}
	
	$dns = $virtualNetworkConfiguration.GetElementsByTagName("Dns")
	if ($dns.count -eq 0)
	{
		$newDns = create-newXmlNode -nodeName "Dns"
		$dns = $virtualNetworkConfiguration.AppendChild($newDns)
	}
	
	$virtualNetworkSites = $virtualNetworkConfiguration.GetElementsByTagName("VirtualNetworkSites")
	if ($virtualNetworkSites.count -eq 0)
	{
		$newVirtualNetworkSites = create-newXmlNode -nodeName "VirtualNetworkSites"
		$virtualNetworkSites = $virtualNetworkConfiguration.AppendChild($newVirtualNetworkSites)
	}
	
	return $workingVnetConfig
}

#Function Source: https://blogs.blackmarble.co.uk/blogs/rhepworth/post/2014/03/04/Creating-Azure-Virtual-Networks-using-Powershell-and-XML-Part-2-Powershell-functions.aspx
function save-azureNetworkXml($workingVnetConfig)
{
	$tempFileName = $env:TEMP + "\azurevnetconfig.netcfg"
	$workingVnetConfig.save($tempFileName)
	#notepad $tempFileName
	set-AzureVNetConfig -configurationpath $tempFileName
}

#Function Source: https://blogs.blackmarble.co.uk/blogs/rhepworth/post/2014/03/04/Creating-Azure-Virtual-Networks-using-Powershell-and-XML-Part-2-Powershell-functions.aspx
#Change code from afinity groups to location
function add-azureVnetNetwork
{
	param
	(
		[string]$networkName,
		[string]$Azurelocation,
		[string]$addressPrefix
	)
	
	#check if the network already exists
	$networkExists = $workingVnetConfig.GetElementsByTagName("VirtualNetworkSite") | where { $_.name -eq $networkName }
	if ($networkExists.Count -ne 0)
	{
		write-Output "Network $networkName already exists"
		$newNetwork = $null
		return $newNetwork
	}
	
	#check that the target affinity group exists
	$AzureLocationExists = Get-AzureLocation | where { $_.name -eq $Azurelocation }
	if ($AzureLocationExists -eq $null)
	{
		write-Output "Azurelocation $Azurelocation does not exist"
		$newNetwork = $null
		return $newNetwork
	}
	
	#get the parent node
	$workingNode = $workingVnetConfig.GetElementsByTagName("VirtualNetworkSites")
	#add the new network node
	$newNetwork = create-newXmlNode -nodeName "VirtualNetworkSite"
	$newNetwork.SetAttribute("name", $networkName)
	$newNetwork.SetAttribute("Location", $Azurelocation)
	$network = $workingNode.appendchild($newNetwork)
	
	#add new address space node
	$newAddressSpace = create-newXmlNode -nodeName "AddressSpace"
	$AddressSpace = $Network.appendchild($newAddressSpace)
	$newAddressPrefix = create-newXmlNode -nodeName "AddressPrefix"
	$newAddressPrefix.InnerText = $addressPrefix
	$AddressSpace.appendchild($newAddressPrefix)
	
	#return our new network
	$newNetwork = $network
	return $newNetwork
	
}



#Function Source: https://blogs.blackmarble.co.uk/blogs/rhepworth/post/2014/03/04/Creating-Azure-Virtual-Networks-using-Powershell-and-XML-Part-2-Powershell-functions.aspx
function add-azureVnetSubnet
{
	param
	(
		[string]$networkName,
		[string]$subnetName,
		[string]$addressPrefix
	)
	
	#get our target network
	$workingNode = $workingVnetConfig.GetElementsByTagName("VirtualNetworkSite") | where { $_.name -eq $networkName }
	if ($workingNode.Count -eq 0)
	{
		write-Output "Network $networkName does not exist"
		$newSubnet = $null
		return $newSubnet
	}
	
	#check if the subnets node exists and if not, create
	$subnets = $workingNode.GetElementsByTagName("Subnets")
	if ($subnets.count -eq 0)
	{
		$newSubnets = create-newXmlNode -nodeName "Subnets"
		$subnets = $workingNode.appendchild($newSubnets)
	}
	
	#check to make sure our subnet name doesn't exist and/or prefix isn't already there
	$subNetExists = $workingNode.GetElementsByTagName("Subnet") | where { $_.name -eq $subnetName }
	if ($subNetExists.count -ne 0)
	{
		write-Output "Subnet $subnetName already exists"
		$newSubnet = $null
		return $newSubnet
	}
	$subNetExists = $workingNode.GetElementsByTagName("Subnet") | where { $_.AddressPrefix -eq $subnetName }
	if ($subNetExists.count -ne 0)
	{
		write-Output "Address prefix $addressPrefix already exists in another network"
		$newSubnet = $null
		return $newSubnet
	}
	
	#add the subnet
	$newSubnet = create-newXmlNode -nodeName "Subnet"
	$newSubnet.SetAttribute("name", $subnetName)
	$subnet = $subnets.appendchild($newSubnet)
	$newAddressPrefix = create-newXmlNode -nodeName "AddressPrefix"
	$newAddressPrefix.InnerText = $addressPrefix
	$subnet.appendchild($newAddressPrefix)
	
	#return our new subnet
	$newSubnet = $subnet
	return $newSubnet
}

#Function Source: https://blogs.blackmarble.co.uk/blogs/rhepworth/post/2014/03/04/Creating-Azure-Virtual-Networks-using-Powershell-and-XML-Part-2-Powershell-functions.aspx
function add-azureVnetDns
{
	param
	(
		[string]$dnsName,
		[string]$dnsAddress
	)
	
	#check that the DNS does not exist
	$dnsExists = $workingVnetConfig.GetElementsByTagName("DnsServer") | where { $_.name -eq $dnsName }
	if ($dnsExists.Count -ne 0)
	{
		write-Output "DNS Server $dnsName already exists"
		$newDns = $null
		return $newDns
	}
	# get our working node of Dns
	$workingNode = $workingVnetConfig.GetElementsByTagName("Dns")
	
	#check if the DnsServersRef node exists and if not, create
	$dnsServers = $workingNode.GetElementsByTagName("DnsServers")
	if ($dnsServers.count -eq 0)
	{
		$newDnsServers = create-newXmlNode -nodeName "DnsServers"
		$dnsServers = $workingNode.appendchild($newDnsServers)
	}
	
	#add new dns reference
	$newDnsServer = create-newXmlNode -nodeName "DnsServer"
	$newDnsServer.SetAttribute("name", $dnsName)
	$newDnsServer.SetAttribute("IPAddress", $dnsAddress)
	$newDns = $dnsServers.appendchild($newDnsServer)
	
	#return our new dnsRef
	return $newDns
	
}

#Function Source: https://blogs.blackmarble.co.uk/blogs/rhepworth/post/2014/03/04/Creating-Azure-Virtual-Networks-using-Powershell-and-XML-Part-2-Powershell-functions.aspx
function add-azureVnetDnsRef
{
	param
	(
		[string]$networkName,
		[string]$dnsName
	)
	
	#get our target network
	$workingNode = $workingVnetConfig.GetElementsByTagName("VirtualNetworkSite") | where { $_.name -eq $networkName }
	if ($workingNode.count -eq 0)
	{
		write-Output "Network $networkName does not exist"
		$newSubnet = $null
		return $newSubnet
	}
	
	#check if the DnsServersRef node exists and if not, create
	$dnsServersRef = $workingNode.GetElementsByTagName("DnsServersRef")
	if ($dnsServersRef.count -eq 0)
	{
		$newDnsServersRef = create-newXmlNode -nodeName "DnsServersRef"
		$dnsServersRef = $workingNode.appendchild($newDnsServersRef)
	}
	
	#check that the DNS we want to reference is defined already
	$dnsExists = $workingVnetConfig.GetElementsByTagName("DnsServer") | where { $_.name -eq $dnsName }
	if ($dnsExists.Count -eq 0)
	{
		write-Output "DNS Server $dnsName does not exist so cannot be referenced"
		$newDnsRef = $null
		return $newDnsRef
	}
	
	#check that the dns reference isn't already there
	$dnsRefExists = $workingNode.GetElementsByTagName("DnsServerRef") | where { $_.name -eq $dnsName }
	if ($dnsRefExists.count -ne 0)
	{
		write-Output "DNS reference $dnsName already exists"
		$newDnsRef = $null
		return $newDnsRef
	}
	
	#add new dns reference
	$newDnsServerRef = create-newXmlNode -nodeName "DnsServerRef"
	$newDnsServerRef.SetAttribute("name", $dnsName)
	$newDnsRef = $dnsServersRef.appendchild($newDnsServerRef)
	
	#return our new dnsRef
	return $newDnsRef
	
}

#Function Source: https://blogs.blackmarble.co.uk/blogs/rhepworth/post/2014/03/04/Creating-Azure-Virtual-Networks-using-Powershell-and-XML-Part-2-Powershell-functions.aspx
function create-newXmlNode
{
	param
	(
		[string]$nodeName
	)
	
	$newNode = $workingVnetConfig.CreateElement($nodeName, "http://schemas.microsoft.com/ServiceHosting/2011/07/NetworkConfiguration")
	return $newNode
}

function Get-FreeServiceName($serviceNameToCheck, $service) #service type are Storage / Service / ServiceBusNamespace
{
	do
	{
		$TimeStamp = get-date -UFormat "%m%d%H%M%S"
		$AccountName = $serviceNameToCheck + $TimeStamp
		if ($service -eq "Storage") { $testresult = Test-AzureName -Storage -Name $AccountName }
		if ($service -eq "Service") { $testresult = Test-AzureName -Service -Name $AccountName }
		if ($service -eq "ServiceBusName") { $testresult = Test-AzureName -ServiceBusNamespace -Name $AccountName }
	}
	while ($testresult -eq $true)
	return $AccountName
}
#source: https://bernhardelbl.wordpress.com/2013/03/21/download-and-install-a-certificate-to-your-trusted-root-using-powershell/
function Install-SelfSignetCert ($url)
{
	Write-Host "used url: $url"
	[Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
	[System.Uri]$u = New-Object System.Uri($url)
	[Net.ServicePoint]$sp = [Net.ServicePointManager]::FindServicePoint($u);
	[System.Guid]$groupName = [System.Guid]::NewGuid()
	# // create a request
	[Net.HttpWebRequest]$req = [Net.WebRequest]::create($url)
	$req.Method = "GET"
	$req.Timeout = 600000 # = 10 minutes
	$req.ConnectionGroupName = $groupName
	# // Set if you need a username/password to access the resource
	#$req.Credentials = New-Object Net.NetworkCredential("username", "password");
	[Net.HttpWebResponse]$result = $req.GetResponse()
	$sp.CloseConnectionGroup($groupName)
	$fullPathIncFileName = $MyInvocation.MyCommand.Definition
	$currentScriptName = $MyInvocation.MyCommand.Name
	$currentExecutingPath = $fullPathIncFileName.Replace($currentScriptName, "")
	$outfilename = $env:temp + "\Export.cer"
	[System.Byte[]]$data = $sp.Certificate.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert)
	if ((Test-Path $outfilename) -eq $true) { rm $outfilename }
	Update-MessageStatus -newmessage "Download self signed certificate $outfilename"
	[System.IO.File]::WriteAllBytes("$outfilename", $data)
	CertUtil -addStore Root "$outfilename"
	Update-MessageStatus -newmessage "Certificate added"
}

function Create-RDPFile ($gateway, $client, $Username,$Action)
{
	$rdp =@"
screen mode id:i:2
use multimon:i:0
desktopwidth:i:1600
desktopheight:i:900
session bpp:i:32
winposstr:s:0,3,0,0,800,600
compression:i:1
keyboardhook:i:2
audiocapturemode:i:0
videoplaybackmode:i:1
connection type:i:7
networkautodetect:i:1
bandwidthautodetect:i:1
displayconnectionbar:i:1
enableworkspacereconnect:i:0
disable wallpaper:i:0
allow font smoothing:i:0
allow desktop composition:i:0
disable full window drag:i:1
disable menu anims:i:1
disable themes:i:0
disable cursor setting:i:0
bitmapcachepersistenable:i:1
full address:s:$client
audiomode:i:0
redirectprinters:i:1
redirectcomports:i:0
redirectsmartcards:i:1
redirectclipboard:i:1
redirectposdevices:i:0
drivestoredirect:s:
autoreconnection enabled:i:1
authentication level:i:2
prompt for credentials:i:0
negotiate security layer:i:1
remoteapplicationmode:i:0
alternate shell:s:
shell working directory:s:
gatewayhostname:s:$gateway
gatewayusagemethod:i:1
gatewaycredentialssource:i:4
gatewayprofileusagemethod:i:1
promptcredentialonce:i:1
gatewaybrokeringtype:i:0
use redirection server name:i:0
rdgiskdcproxy:i:0
kdcproxyname:s:
username:s:$Username

"@
	$outfilename = $env:temp + "\cloudserver.rdp"
	
	if ($Action -eq "StartSession")
	{
		if ((Test-Path $outfilename) -eq $true) { rm $outfilename }
		$rdp | Out-File $outfilename
		Update-MessageStatus -newmessage "Start remote desktop session using: $outfilename"
		. $outfilename
	}
	else
	{
		$file = Get-SaveRdpFile
		if ((Test-Path $file) -eq $true) { rm $file }
		$rdp | Out-File $file
		Update-MessageStatus -newmessage "Your RDP file is ready and stored here: $file"
	}
	#if ((Test-Path $outfilename) -eq $true) { rm $outfilename }
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory


