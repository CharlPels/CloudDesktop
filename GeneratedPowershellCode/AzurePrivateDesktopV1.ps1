
#----------------------------------------------
#region Import Assemblies
#----------------------------------------------
[void][Reflection.Assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][Reflection.Assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.DirectoryServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][Reflection.Assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.ServiceProcess, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
#endregion Import Assemblies

#Define a Param block to use custom parameters in the project
#Param ($CustomParameter)

function Main {
	Param ([String]$Commandline)
	
	if((Call-MainForm_psf) -eq 'OK')
	{
		
	}
	
	$global:ExitCode = 0 #Set the exit code for the Packager
}






#endregion Source: Startup.pss

#region Source: MainForm.psf
function Call-MainForm_psf
{

	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.DirectoryServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.ServiceProcess, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$MainForm = New-Object 'System.Windows.Forms.Form'
	$ServerDnsName = New-Object 'System.Windows.Forms.Label'
	$labelYourServerName = New-Object 'System.Windows.Forms.Label'
	$labelServerIP = New-Object 'System.Windows.Forms.Label'
	$labelYourServerIP = New-Object 'System.Windows.Forms.Label'
	$messages = New-Object 'System.Windows.Forms.TextBox'
	$buttonConnect = New-Object 'System.Windows.Forms.Button'
	$SubscriptionIDSelected = New-Object 'System.Windows.Forms.Label'
	$label2 = New-Object 'System.Windows.Forms.Label'
	$labelServiceName = New-Object 'System.Windows.Forms.Label'
	$labelYourServiceName = New-Object 'System.Windows.Forms.Label'
	$labelServerName = New-Object 'System.Windows.Forms.Label'
	$labelYourRDPServer = New-Object 'System.Windows.Forms.Label'
	$buttonStopServer = New-Object 'System.Windows.Forms.Button'
	$buttonStartServer = New-Object 'System.Windows.Forms.Button'
	$SubscriptionSelected = New-Object 'System.Windows.Forms.Label'
	$labelSelectedSubscription = New-Object 'System.Windows.Forms.Label'
	$menustrip1 = New-Object 'System.Windows.Forms.MenuStrip'
	$loginToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$refreshToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$destopTasksToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$deployNewDesktopToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$removeOldDesktopToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$mediumToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$configurationToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$helpToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$aboutToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$largeToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$smallToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$createRemoteDesktopFileToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$azurePortalToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$azurePreviewPortalToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$makeDesktopOfThisServerToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$cloudDesktopSiteToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	#Import-Module Storage
	function Get-ServerStatatusAndUpdateForm
	{
		Update-MessageStatus -newmessage "Get latest Azure server information"
		$ServiceName = Get-AzureService | where { $_.ServiceName -like "RDPService*" }
		try { $Servicevm = (Get-AzureVM -ServiceName $ServiceName.ServiceName)[0] }
		catch
		{}
		$labelServerName.Text = $Servicevm.name
		$labelServiceName.Text = $Servicevm.ServiceName
		if ($Servicevm.PowerState -eq "Stopped")
		{
			$buttonStartServer.Visible = $true
			$buttonStopServer.Visible = $false
			$removeOldDesktopToolStripMenuItem.Visible = $true
			$buttonConnect.Visible = $false
			$createRemoteDesktopFileToolStripMenuItem.Visible = $True
		}
		else
		{
			$buttonStartServer.Visible = $false
			$buttonStopServer.Visible = $True
			$buttonConnect.Visible = $True
			$removeOldDesktopToolStripMenuItem.Visible = $true
			$createRemoteDesktopFileToolStripMenuItem.Visible = $true
			
			#Get Ip information
	#		try
	#		{
				$serviceinfo = Get-AzureService $labelServiceName.Text
				$global:vip = (Get-AzureVM -ServiceName $labelServiceName.Text -Name $labelServerName.text | Get-AzureEndpoint)[0].Vip #| Select-Object -First 1)
				$labelServerIP.Text = $global:vip
	#		}
	#		catch
	#		{
	#			[System.Windows.Forms.MessageBox]::Show("Looks like there are communication issues, we will close the Application")
	#			$MainForm.Close()
	#		}
			
		}
		$destopTasksToolStripMenuItem.Visible = $true #Show the DesktopTasksMenu option
		if ($Servicevm.count -eq 0)
		{
			$buttonStartServer.Visible = $false
			$buttonStopServer.Visible = $false
			$deployNewDesktopToolStripMenuItem.Visible = $true
			$removeOldDesktopToolStripMenuItem.Visible = $false
			$buttonConnect.Visible = $false
			$createRemoteDesktopFileToolStripMenuItem.Visible = $false
		}
	
		
	}
	
	function new-desktop($instanceSize , $vmName = "rdpsvr1")
	{
		if ($global:adminUser -ne "none" -and $global:adminUser -ne "none")
		{
			#Create the network we place the RDPGateway in, this way we can add more servers if needed :-)
			$workingVnetConfig = get-azurenetworkxml
			add-azureVnetNetwork -networkName $CloudNetwork -Azurelocation $location -addressPrefix "10.10.10.0/23"
			add-azureVnetSubnet -networkName $CloudNetwork -subnetName $subNetName1 -addressPrefix "10.10.10.0/24"
			add-azureVNetDns -dnsName "google" -dnsAddress "8.8.8.8"
			add-azureVnetDnsRef -networkName $CloudNetwork -dnsName "google"
			Update-MessageStatus -newmessage "Checking and updating network configuration"
			save-azurenetworkxml($workingVnetConfig)
			
			
			#Check and Create storage account
			Update-MessageStatus -newmessage "Check for storage account and create one if needed"
			$rdpserverstore = Get-AzureStorageAccount | where { $_.StorageAccountName -like "rdpserverstore*" }
			if ($rdpserverstore.count -eq 0)
			{
				Write-Host "No rdp serverstore found, will create one now, this my take up to 15 min"
				$StorageAccountName = Get-FreeServiceName -service storage -serviceNameToCheck rdpserverstore
				Write-Host "Store created is $StorageAccountName"
				$StorageAccount = New-AzureStorageAccount -Location $location -Description "Used for RDP Gateway server solution" -StorageAccountName $StorageAccountName -Label "RDPServerStore" -Type "Standard_LRS"
				$rdpserverstore = Get-AzureStorageAccount | where { $_.StorageAccountName -like "rdpserverstore*" }
				
			}
			
			set-azuresubscription -SubscriptionId $SubscriptionIDSelected.Text -CurrentStorageAccountName $rdpserverstore.StorageAccountName
			$storageEndpoint = $rdpserverstore.Endpoints | where{ $_ -like "*blob*" }
			
			
			
			#Find Existing service name or create a new one
			$ServiceName = (Get-AzureService).label | where { $_ -like "RDPService*" }
			if ($ServiceName.count -eq 0)
			{
				#Get a free servicename
				$ServiceName = Get-FreeServiceName -service service -serviceNameToCheck RDPService
			}
			$vms = (Get-AzureVM -ServiceName $ServiceName)
			if ($vms.count -eq 0)
			{
				#no server detected, create one now
				[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') | Out-Null
				$global:password = [Microsoft.VisualBasic.Interaction]::InputBox("Please enter a password you want to use for your cloud desktop?","Enter Password")
				Update-MessageStatus -newmessage "No Server detected, will deploy a new one for you"
				Update-MessageStatus -newmessage "Username will be: $global:adminUser"
				$Arguments = $global:cpelsEmail + " " + $global:cpelsSerial
				$imageFamily = "Windows Server 2012 R2 Datacenter"
				$imageName = Get-AzureVMImage | where { $_.ImageFamily -eq $imageFamily } | sort PublishedDate -Descending | select -ExpandProperty ImageName -First 1
				
				$osDisk = $storageEndpoint + "disks/$vmName" + "os.vhd"
				#$data1 = $storageEndpoint + "disks/$vmName" + "data1.vhd"
				#$data2 = $storageEndpoint + "disks/$vmName" + "data2.vhd”
				
				#Add-AzureDataDisk -CreateNew -DiskSizeInGB 10 -LUN 0 -DiskLabel "data" -MediaLocation $data1 |
				#Set-AzureStaticVNetIP -IPAddress 10.0.1.16 |
				$vm1 = New-AzureVMConfig -ImageName $imageName -InstanceSize $instanceSize -Name $vmName -Label $vmName -MediaLocation $osDisk -AvailabilitySetName "AVset01" -DiskLabel "OS Disk" |
				Set-AzureSubnet $subNetName1 |
				Add-AzureEndpoint -LocalPort 3389 -Name 'RDP' -Protocol tcp -PublicPort 3389 |
				Add-AzureEndpoint -LocalPort 80 -Name 'http' -Protocol tcp -PublicPort 80 |
				Add-AzureEndpoint -LocalPort 443 -Name 'https' -Protocol tcp -PublicPort 443 |
				Add-AzureProvisioningConfig -Windows -AdminUsername $global:adminUser -Password $global:password |
				Set-AzureVMCustomScriptExtension -FileUri "https://remotedesktopscripts.blob.core.windows.net/rdpgateway-scripts/standaloneRDPGatewayConfig.ps1" -Run "standaloneRDPGatewayConfig.ps1" -Argument $Arguments
				New-AzureVM -VNetName $CloudNetwork –ServiceName $serviceName -vms $vm1 -Location "West Europe"
			}
			sleep 5
			Get-ServerStatatusAndUpdateForm
		}
		else
		{
			[System.Windows.Forms.MessageBox]::Show("No Windows username and password configured, please first go to configuration section")
		}
	}
	
	
	$MainForm_Load = {
		
		$os_caption = (Get-WmiObject -Class Win32_OperatingSystem | ForEach-Object -MemberName Caption)
		if ($os_caption -like "*Windows Server 2012 R2*")
		{
			$makeDesktopOfThisServerToolStripMenuItem.Visible = $true
			$deployNewDesktopToolStripMenuItem.Visible = $true
		}
		else
		{$makeDesktopOfThisServerToolStripMenuItem.Visible = $false}
		
		$response = $cpelsService.LatestRdpVersion()
		if ($response[0] -ne "1.1")
		{
			[System.Windows.Forms.MessageBox]::Show($response[1])  
		}
	
		#Get registry values
		$global:RegistryLocation = "HKCU:\Software\CloudDesktop"
		if ((Test-Path $global:RegistryLocation) -eq $false)
		{
			try { mkdir $RegistryLocation }
			catch { }
		}
		try { $global:adminUser = (Get-ItemProperty -Path $RegistryLocation -Name adminuser).adminuser } Catch { }
		if ($global:adminUser -eq $null)
		{
			Set-ItemProperty -Path $RegistryLocation -Name adminuser -Value "none"
			$global:adminUser = "none"
		}
		try { $global:cpelsEmail = (Get-ItemProperty -Path $RegistryLocation -Name cpelsEmail).cpelsEmail }
		Catch { }
		if ($global:cpelsEmail-eq $null)
		{
			Set-ItemProperty -Path $RegistryLocation -Name cpelsEmail -Value "none"
			$global:cpelsEmail = "none"
		}
		try { $global:cpelsSerial= (Get-ItemProperty -Path $RegistryLocation -Name cpelsSerial).cpelsSerial }
		Catch { }
		if ($global:cpelsSerial -eq $null)
		{
			Set-ItemProperty -Path $RegistryLocation -Name cpelsSerial -Value "none"
			$global:cpelsSerial = "none"
		}
		
		$reply = $cpelsService.CloudUser($global:cpelsEmail, $global:cpelsSerial)
		if ($reply[0] -eq "error")
		{
			if ($global:cpelsEmail -ne "none") { [System.Windows.Forms.MessageBox]::Show("Your cpels Email and or serial is not correct, please check your configuration settings") }
	#		Set-ItemProperty -Path $RegistryLocation -Name cpelsEmail -Value "none"
	#		Set-ItemProperty -Path $RegistryLocation -Name cpelsSerial -Value "none"
	#		$global:cpelsEmail = "none"
	#		$global:cpelsSerial = "none"
			$ServerDnsName.Visible = $false
			$labelYourServerName.Visible = $false
			$ServerDnsName.Text = ""
		}
		else
		{
			$ServerDnsName.Text = $reply[2]
			$ServerDnsName.Visible = $true
			$labelYourServerName.Visible = $true
	
		}
		#TODO: Initialize Form Controls here
		."C:\Program Files (x86)\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\ShortcutStartup.ps1"
		Update-MessageStatus -newmessage "Welcome"
		#Disable/hide Some buttons
		$buttonStartServer.Visible = $false
		$buttonStopServer.Visible = $false
		$buttonConnect.Visible = $false
		
		#DisableMenuItems
		$deployNewDesktopToolStripMenuItem.Visible = $false
		$removeOldDesktopToolStripMenuItem.Visible = $false
		$destopTasksToolStripMenuItem.Visible = $false
		$refreshToolStripMenuItem.Visible = $false
		
		#Make it possible to convert every windows 2012 r2 server to RDP Gateway
		$os_caption = (Get-WmiObject -Class Win32_OperatingSystem | ForEach-Object -MemberName Caption)
		if ($os_caption -like "*Windows Server 2012 R2*")
		{
			$makeDesktopOfThisServerToolStripMenuItem.Visible = $true
			$destopTasksToolStripMenuItem.Visible = $true
		}
		else
		{ $makeDesktopOfThisServerToolStripMenuItem.Visible = $false }
		
	}
	
	
	
	
	
	
	$loginToolStripMenuItem_Click={
	
		#Call-LoginForm_psf
		
		try { get-azureService }
		catch
		{
			Add-AzureAccount
			$subscription = Get-AzureSubscription
		}
		$subscription = Get-AzureSubscription
		if ($subscription.count -eq 0)
		{
			[System.Windows.Forms.MessageBox]::Show("Seems that login to Azure was not successful, please try again") 
		}
		else
		{
			$subscription = $subscription | Out-GridView -OutputMode Single
			if ($subscription.count -eq 1)
			{
				$subscription = Get-AzureSubscription -SubscriptionName $subscription.SubscriptionName #Added this extra get-azuresubscription because gritview result is not picketup correctly
				Select-AzureSubscription -SubscriptionId $subscription.SubscriptionId
				$subscriptionSelected.text = $subscription.SubscriptionName
				$SubscriptionIDSelected.text = $subscription.SubscriptionId
				set-azuresubscription -SubscriptionId $subscription.SubscriptionId
				Get-ServerStatatusAndUpdateForm #Update buttoms so user can start/stop servers
				$refreshToolStripMenuItem.Visible = $true
			}
			else
			{
				[System.Windows.Forms.MessageBox]::Show("So subscription selected")
			}
		}
	}
	
	
	
	
	
	
	$buttonStopServer_Click={
		#TODO: Place custom script here
		$global:vip = ""
		$messages.AppendText("Stop Server")
		Stop-AzureVM -Name $labelServerName.Text -ServiceName $labelServiceName.Text -force
		Get-ServerStatatusAndUpdateForm
	}
	
	
	
	$buttonStartServer_Click={
		#TODO: Place custom script here
		$messages.AppendText("Start Server")
		Start-AzureVM -Name $labelServerName.Text -ServiceName $labelServiceName.Text
		Get-ServerStatatusAndUpdateForm
	}
	
	
	
	
	
	
	
	
	
	
	$mediumToolStripMenuItem_Click={
		#TODO: Place custom script here
		new-desktop -instanceSize "Medium" -vmName "rdpsvr1"
	}
	
	
	
	
	
	$removeOldDesktopToolStripMenuItem_Click={
		#TODO: Place custom script here
		$ServiceName = Get-AzureService | where { $_.ServiceName -like "RDPService*" }
		try { $Servicevm = (Get-AzureVM -ServiceName $ServiceName.ServiceName)[0] }
		catch
		{ }
		if ($Servicevm.PowerState -ne "Stopped")
		{
			$messages.AppendText("Stop Server")
			Stop-AzureVM -Name $labelServerName.Text -ServiceName $labelServiceName.Text -force
			Get-ServerStatatusAndUpdateForm
		}
		Update-MessageStatus -newmessage "Start removing your old server"
		Remove-AzureVM -Name $labelServerName.Text -DeleteVHD -ServiceName $labelServiceName.Text
		Update-MessageStatus -newmessage "Old server removed"
		sleep 20
		Get-ServerStatatusAndUpdateForm
	}
	
	
	$buttonConnect_Click={
		if ($ServerDnsName.Text -eq "")
		{
			$gateway = $global:vip
			#Add self signet certificate to root store of your device
			$url = "https://$global:vip/rdweb"
			$testurl = "http://$global:vip"
			Update-MessageStatus -newmessage "Your server has public IP: $global:vip"
			Update-MessageStatus -newmessage "Your server website is: $url"
			Sleep-tillWebsiteIsUp -url $testurl
			Install-SelfSignetCert $url
		}
		else { $gateway = $ServerDnsName.Text}
		$rdpuseraccount = $labelServerName.text + "\" + $global:adminUser
		Create-RDPFile -client $labelServerName.text -gateway $gateway -Username $rdpuseraccount -Action "StartSession"
	
	}
	
	
	$configurationToolStripMenuItem_Click={
		#TODO: Place custom script here
		Call-ConfigurationScreen_psf
	}
	
	$aboutToolStripMenuItem_Click={
		#TODO: Place custom script here
		Call-about_psf
	}
	
	$smallToolStripMenuItem_Click={
		#TODO: Place custom script here
		new-desktop -instanceSize "Small" -vmName "rdpsvr1"
	}
	
	$largeToolStripMenuItem_Click={
		#TODO: Place custom script here
		new-desktop -instanceSize "Large" -vmName "rdpsvr1"
	}
	
	$createRemoteDesktopFileToolStripMenuItem_Click={
		if ($ServerDnsName.Text -eq "") { $gateway = $vip }
		else { $gateway = $ServerDnsName.Text }
		$rdpuseraccount = $labelServerName.text + "\" + $global:adminUser
		Create-RDPFile -client $labelServerName.text -gateway $gateway -Username $rdpuseraccount -Action "CreateRDP"
		
	}
	
	
	
	$refreshToolStripMenuItem_Click={
		Get-ServerStatatusAndUpdateForm
	}
	
	$azurePortalToolStripMenuItem_Click={
		Start-Process 'https://manage.windowsazure.com/'
	}
	
	$azurePreviewPortalToolStripMenuItem_Click={
		Start-Process 'https://portal.azure.com/'
	}
	
	$makeDesktopOfThisServerToolStripMenuItem_Click={
		$OUTPUT = [System.Windows.Forms.MessageBox]::Show("If you are not shure what you are dooing please read the manual!!!. Do you want this server to become your desktop server?", "Status", 4)
		if ($OUTPUT -eq "YES")
		{
			
			mkdir "c:\support"
			$source = "https://remotedesktopscripts.blob.core.windows.net/rdpgateway-scripts/standaloneRDPGatewayConfig.ps1"
			$destination = "c:\support\standaloneRDPGatewayConfig.ps1"
			Invoke-WebRequest $source -OutFile $destination
			$Arguments = $global:cpelsEmail + " " + $global:cpelsSerial
			#Invoke-Expression "$destination $Arguments"
			Update-MessageStatus -newmessage "We are now altering your server to be a Desktop"
			Update-MessageStatus -newmessage "This can take a while depending on your system, please be patient."
			powershell "$destination $Arguments"
			Update-MessageStatus -newmessage "Installation is finished."
			Update-MessageStatus -newmessage "Please make Shure your server is reachable from internet and has all security updates"
		}
		else
		{
			[System.Windows.Forms.MessageBox]::Show("job cancelled")
		}
		
	}
	
	
	
	$cloudDesktopSiteToolStripMenuItem_Click={
		Start-Process 'https://sites.google.com/a/cpels.nl/www-cpels-nl/cloud-desktop'
	}
		# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$MainForm.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
		$script:MainForm_messages = $messages.Text
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonConnect.remove_Click($buttonConnect_Click)
			$buttonStopServer.remove_Click($buttonStopServer_Click)
			$buttonStartServer.remove_Click($buttonStartServer_Click)
			$MainForm.remove_Load($MainForm_Load)
			$loginToolStripMenuItem.remove_Click($loginToolStripMenuItem_Click)
			$refreshToolStripMenuItem.remove_Click($refreshToolStripMenuItem_Click)
			$removeOldDesktopToolStripMenuItem.remove_Click($removeOldDesktopToolStripMenuItem_Click)
			$mediumToolStripMenuItem.remove_Click($mediumToolStripMenuItem_Click)
			$configurationToolStripMenuItem.remove_Click($configurationToolStripMenuItem_Click)
			$aboutToolStripMenuItem.remove_Click($aboutToolStripMenuItem_Click)
			$largeToolStripMenuItem.remove_Click($largeToolStripMenuItem_Click)
			$smallToolStripMenuItem.remove_Click($smallToolStripMenuItem_Click)
			$createRemoteDesktopFileToolStripMenuItem.remove_Click($createRemoteDesktopFileToolStripMenuItem_Click)
			$azurePortalToolStripMenuItem.remove_Click($azurePortalToolStripMenuItem_Click)
			$azurePreviewPortalToolStripMenuItem.remove_Click($azurePreviewPortalToolStripMenuItem_Click)
			$makeDesktopOfThisServerToolStripMenuItem.remove_Click($makeDesktopOfThisServerToolStripMenuItem_Click)
			$cloudDesktopSiteToolStripMenuItem.remove_Click($cloudDesktopSiteToolStripMenuItem_Click)
			$MainForm.remove_Load($Form_StateCorrection_Load)
			$MainForm.remove_Closing($Form_StoreValues_Closing)
			$MainForm.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch [Exception]
		{ }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$MainForm.SuspendLayout()
	$menustrip1.SuspendLayout()
	#
	# MainForm
	#
	$MainForm.Controls.Add($ServerDnsName)
	$MainForm.Controls.Add($labelYourServerName)
	$MainForm.Controls.Add($labelServerIP)
	$MainForm.Controls.Add($labelYourServerIP)
	$MainForm.Controls.Add($messages)
	$MainForm.Controls.Add($buttonConnect)
	$MainForm.Controls.Add($SubscriptionIDSelected)
	$MainForm.Controls.Add($label2)
	$MainForm.Controls.Add($labelServiceName)
	$MainForm.Controls.Add($labelYourServiceName)
	$MainForm.Controls.Add($labelServerName)
	$MainForm.Controls.Add($labelYourRDPServer)
	$MainForm.Controls.Add($buttonStopServer)
	$MainForm.Controls.Add($buttonStartServer)
	$MainForm.Controls.Add($SubscriptionSelected)
	$MainForm.Controls.Add($labelSelectedSubscription)
	$MainForm.Controls.Add($menustrip1)
	$MainForm.ClientSize = '530, 355'
	$MainForm.MainMenuStrip = $menustrip1
	$MainForm.Name = 'MainForm'
	$MainForm.StartPosition = 'CenterScreen'
	$MainForm.Text = 'Your Cloud Desktop'
	$MainForm.add_Load($MainForm_Load)
	#
	# ServerDnsName
	#
	$ServerDnsName.Location = '136, 143'
	$ServerDnsName.Name = 'ServerDnsName'
	$ServerDnsName.Size = '190, 23'
	$ServerDnsName.TabIndex = 16
	$ServerDnsName.Text = 'ServerDnsName'
	#
	# labelYourServerName
	#
	$labelYourServerName.Location = '12, 142'
	$labelYourServerName.Name = 'labelYourServerName'
	$labelYourServerName.Size = '117, 23'
	$labelYourServerName.TabIndex = 15
	$labelYourServerName.Text = 'Your Server Name:'
	#
	# labelServerIP
	#
	$labelServerIP.Location = '136, 120'
	$labelServerIP.Name = 'labelServerIP'
	$labelServerIP.Size = '190, 23'
	$labelServerIP.TabIndex = 14
	$labelServerIP.Text = 'ServerIP'
	#
	# labelYourServerIP
	#
	$labelYourServerIP.Location = '12, 119'
	$labelYourServerIP.Name = 'labelYourServerIP'
	$labelYourServerIP.Size = '117, 23'
	$labelYourServerIP.TabIndex = 13
	$labelYourServerIP.Text = 'Your Server IP:'
	#
	# messages
	#
	$messages.Location = '12, 238'
	$messages.Multiline = $True
	$messages.Name = 'messages'
	$messages.ReadOnly = $True
	$messages.ScrollBars = 'Vertical'
	$messages.Size = '506, 105'
	$messages.TabIndex = 12
	#
	# buttonConnect
	#
	$buttonConnect.BackColor = '255, 255, 192'
	$buttonConnect.Location = '174, 169'
	$buttonConnect.Name = 'buttonConnect'
	$buttonConnect.Size = '75, 49'
	$buttonConnect.TabIndex = 11
	$buttonConnect.Text = 'Connect'
	$buttonConnect.UseVisualStyleBackColor = $False
	$buttonConnect.add_Click($buttonConnect_Click)
	#
	# SubscriptionIDSelected
	#
	$SubscriptionIDSelected.Location = '136, 27'
	$SubscriptionIDSelected.Name = 'SubscriptionIDSelected'
	$SubscriptionIDSelected.Size = '394, 23'
	$SubscriptionIDSelected.TabIndex = 10
	$SubscriptionIDSelected.Text = 'Selected Subscription id'
	#
	# label2
	#
	$label2.Location = '12, 27'
	$label2.Name = 'label2'
	$label2.Size = '133, 23'
	$label2.TabIndex = 9
	$label2.Text = 'Selected Subscription ID:'
	#
	# labelServiceName
	#
	$labelServiceName.Location = '136, 96'
	$labelServiceName.Name = 'labelServiceName'
	$labelServiceName.Size = '190, 23'
	$labelServiceName.TabIndex = 8
	$labelServiceName.Text = 'ServiceName'
	#
	# labelYourServiceName
	#
	$labelYourServiceName.Location = '12, 96'
	$labelYourServiceName.Name = 'labelYourServiceName'
	$labelYourServiceName.Size = '117, 23'
	$labelYourServiceName.TabIndex = 7
	$labelYourServiceName.Text = 'Your Service Name:'
	#
	# labelServerName
	#
	$labelServerName.Location = '136, 73'
	$labelServerName.Name = 'labelServerName'
	$labelServerName.Size = '190, 23'
	$labelServerName.TabIndex = 6
	$labelServerName.Text = 'ServerName'
	#
	# labelYourRDPServer
	#
	$labelYourRDPServer.Location = '12, 73'
	$labelYourRDPServer.Name = 'labelYourRDPServer'
	$labelYourRDPServer.Size = '117, 23'
	$labelYourRDPServer.TabIndex = 5
	$labelYourRDPServer.Text = 'Your RDP server:'
	#
	# buttonStopServer
	#
	$buttonStopServer.BackColor = '255, 192, 192'
	$buttonStopServer.Location = '93, 168'
	$buttonStopServer.Name = 'buttonStopServer'
	$buttonStopServer.Size = '75, 49'
	$buttonStopServer.TabIndex = 4
	$buttonStopServer.Text = 'StopServer'
	$buttonStopServer.UseVisualStyleBackColor = $False
	$buttonStopServer.add_Click($buttonStopServer_Click)
	#
	# buttonStartServer
	#
	$buttonStartServer.BackColor = '192, 255, 192'
	$buttonStartServer.Location = '12, 168'
	$buttonStartServer.Name = 'buttonStartServer'
	$buttonStartServer.Size = '75, 49'
	$buttonStartServer.TabIndex = 3
	$buttonStartServer.Text = 'StartServer'
	$buttonStartServer.UseVisualStyleBackColor = $False
	$buttonStartServer.add_Click($buttonStartServer_Click)
	#
	# SubscriptionSelected
	#
	$SubscriptionSelected.Location = '135, 50'
	$SubscriptionSelected.Name = 'SubscriptionSelected'
	$SubscriptionSelected.Size = '395, 23'
	$SubscriptionSelected.TabIndex = 2
	$SubscriptionSelected.Text = 'Selected Subscription:'
	#
	# labelSelectedSubscription
	#
	$labelSelectedSubscription.Location = '12, 50'
	$labelSelectedSubscription.Name = 'labelSelectedSubscription'
	$labelSelectedSubscription.Size = '117, 23'
	$labelSelectedSubscription.TabIndex = 1
	$labelSelectedSubscription.Text = 'Selected Subscription:'
	#
	# menustrip1
	#
	[void]$menustrip1.Items.Add($loginToolStripMenuItem)
	[void]$menustrip1.Items.Add($refreshToolStripMenuItem)
	[void]$menustrip1.Items.Add($destopTasksToolStripMenuItem)
	[void]$menustrip1.Items.Add($configurationToolStripMenuItem)
	[void]$menustrip1.Items.Add($helpToolStripMenuItem)
	$menustrip1.Location = '0, 0'
	$menustrip1.Name = 'menustrip1'
	$menustrip1.Size = '530, 24'
	$menustrip1.TabIndex = 0
	$menustrip1.Text = 'menustrip1'
	#
	# loginToolStripMenuItem
	#
	$loginToolStripMenuItem.Name = 'loginToolStripMenuItem'
	$loginToolStripMenuItem.Size = '49, 20'
	$loginToolStripMenuItem.Text = 'Login'
	$loginToolStripMenuItem.add_Click($loginToolStripMenuItem_Click)
	#
	# refreshToolStripMenuItem
	#
	$refreshToolStripMenuItem.Name = 'refreshToolStripMenuItem'
	$refreshToolStripMenuItem.Size = '93, 20'
	$refreshToolStripMenuItem.Text = 'Refresh Status'
	$refreshToolStripMenuItem.add_Click($refreshToolStripMenuItem_Click)
	#
	# destopTasksToolStripMenuItem
	#
	[void]$destopTasksToolStripMenuItem.DropDownItems.Add($deployNewDesktopToolStripMenuItem)
	[void]$destopTasksToolStripMenuItem.DropDownItems.Add($makeDesktopOfThisServerToolStripMenuItem)
	[void]$destopTasksToolStripMenuItem.DropDownItems.Add($removeOldDesktopToolStripMenuItem)
	[void]$destopTasksToolStripMenuItem.DropDownItems.Add($createRemoteDesktopFileToolStripMenuItem)
	$destopTasksToolStripMenuItem.Name = 'destopTasksToolStripMenuItem'
	$destopTasksToolStripMenuItem.Size = '91, 20'
	$destopTasksToolStripMenuItem.Text = 'DesktopTasks'
	#
	# deployNewDesktopToolStripMenuItem
	#
	[void]$deployNewDesktopToolStripMenuItem.DropDownItems.Add($smallToolStripMenuItem)
	[void]$deployNewDesktopToolStripMenuItem.DropDownItems.Add($mediumToolStripMenuItem)
	[void]$deployNewDesktopToolStripMenuItem.DropDownItems.Add($largeToolStripMenuItem)
	$deployNewDesktopToolStripMenuItem.Name = 'deployNewDesktopToolStripMenuItem'
	$deployNewDesktopToolStripMenuItem.Size = '234, 22'
	$deployNewDesktopToolStripMenuItem.Text = 'Deploy New Desktop on Azure'
	#
	# removeOldDesktopToolStripMenuItem
	#
	$removeOldDesktopToolStripMenuItem.Name = 'removeOldDesktopToolStripMenuItem'
	$removeOldDesktopToolStripMenuItem.Size = '234, 22'
	$removeOldDesktopToolStripMenuItem.Text = 'Remove Old Desktop'
	$removeOldDesktopToolStripMenuItem.add_Click($removeOldDesktopToolStripMenuItem_Click)
	#
	# mediumToolStripMenuItem
	#
	$mediumToolStripMenuItem.Name = 'mediumToolStripMenuItem'
	$mediumToolStripMenuItem.Size = '119, 22'
	$mediumToolStripMenuItem.Text = 'Medium'
	$mediumToolStripMenuItem.add_Click($mediumToolStripMenuItem_Click)
	#
	# configurationToolStripMenuItem
	#
	$configurationToolStripMenuItem.Name = 'configurationToolStripMenuItem'
	$configurationToolStripMenuItem.Size = '93, 20'
	$configurationToolStripMenuItem.Text = 'Configuration'
	$configurationToolStripMenuItem.add_Click($configurationToolStripMenuItem_Click)
	#
	# helpToolStripMenuItem
	#
	[void]$helpToolStripMenuItem.DropDownItems.Add($cloudDesktopSiteToolStripMenuItem)
	[void]$helpToolStripMenuItem.DropDownItems.Add($azurePortalToolStripMenuItem)
	[void]$helpToolStripMenuItem.DropDownItems.Add($azurePreviewPortalToolStripMenuItem)
	[void]$helpToolStripMenuItem.DropDownItems.Add($aboutToolStripMenuItem)
	$helpToolStripMenuItem.Name = 'helpToolStripMenuItem'
	$helpToolStripMenuItem.Size = '44, 20'
	$helpToolStripMenuItem.Text = 'Help'
	#
	# aboutToolStripMenuItem
	#
	$aboutToolStripMenuItem.Name = 'aboutToolStripMenuItem'
	$aboutToolStripMenuItem.Size = '182, 22'
	$aboutToolStripMenuItem.Text = 'About'
	$aboutToolStripMenuItem.add_Click($aboutToolStripMenuItem_Click)
	#
	# largeToolStripMenuItem
	#
	$largeToolStripMenuItem.Name = 'largeToolStripMenuItem'
	$largeToolStripMenuItem.Size = '119, 22'
	$largeToolStripMenuItem.Text = 'Large'
	$largeToolStripMenuItem.add_Click($largeToolStripMenuItem_Click)
	#
	# smallToolStripMenuItem
	#
	$smallToolStripMenuItem.Name = 'smallToolStripMenuItem'
	$smallToolStripMenuItem.Size = '119, 22'
	$smallToolStripMenuItem.Text = 'Small'
	$smallToolStripMenuItem.add_Click($smallToolStripMenuItem_Click)
	#
	# createRemoteDesktopFileToolStripMenuItem
	#
	$createRemoteDesktopFileToolStripMenuItem.Name = 'createRemoteDesktopFileToolStripMenuItem'
	$createRemoteDesktopFileToolStripMenuItem.Size = '234, 22'
	$createRemoteDesktopFileToolStripMenuItem.Text = 'Create Remote Desktop File'
	$createRemoteDesktopFileToolStripMenuItem.add_Click($createRemoteDesktopFileToolStripMenuItem_Click)
	#
	# azurePortalToolStripMenuItem
	#
	$azurePortalToolStripMenuItem.Name = 'azurePortalToolStripMenuItem'
	$azurePortalToolStripMenuItem.Size = '182, 22'
	$azurePortalToolStripMenuItem.Text = 'Azure Portal'
	$azurePortalToolStripMenuItem.add_Click($azurePortalToolStripMenuItem_Click)
	#
	# azurePreviewPortalToolStripMenuItem
	#
	$azurePreviewPortalToolStripMenuItem.Name = 'azurePreviewPortalToolStripMenuItem'
	$azurePreviewPortalToolStripMenuItem.Size = '182, 22'
	$azurePreviewPortalToolStripMenuItem.Text = 'Azure Preview Portal'
	$azurePreviewPortalToolStripMenuItem.add_Click($azurePreviewPortalToolStripMenuItem_Click)
	#
	# makeDesktopOfThisServerToolStripMenuItem
	#
	$makeDesktopOfThisServerToolStripMenuItem.Name = 'makeDesktopOfThisServerToolStripMenuItem'
	$makeDesktopOfThisServerToolStripMenuItem.Size = '234, 22'
	$makeDesktopOfThisServerToolStripMenuItem.Text = 'Make desktop of this server'
	$makeDesktopOfThisServerToolStripMenuItem.add_Click($makeDesktopOfThisServerToolStripMenuItem_Click)
	#
	# cloudDesktopSiteToolStripMenuItem
	#
	$cloudDesktopSiteToolStripMenuItem.Name = 'cloudDesktopSiteToolStripMenuItem'
	$cloudDesktopSiteToolStripMenuItem.Size = '182, 22'
	$cloudDesktopSiteToolStripMenuItem.Text = 'Cloud Desktop Site'
	$cloudDesktopSiteToolStripMenuItem.add_Click($cloudDesktopSiteToolStripMenuItem_Click)
	$menustrip1.ResumeLayout()
	$MainForm.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $MainForm.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$MainForm.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$MainForm.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$MainForm.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $MainForm.ShowDialog()

}
#endregion Source: MainForm.psf

#region Source: Globals.ps1
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
	
	
	#endregion Source: Globals.ps1

#region Source: ConfigurationScreen.psf
function Call-ConfigurationScreen_psf
{

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.DirectoryServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.ServiceProcess, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formConfiguration = New-Object 'System.Windows.Forms.Form'
	$labelSerial = New-Object 'System.Windows.Forms.Label'
	$labelEmail = New-Object 'System.Windows.Forms.Label'
	$labelCpelsDesktopAccount = New-Object 'System.Windows.Forms.Label'
	$cpelspasword = New-Object 'System.Windows.Forms.TextBox'
	$cpelsEmail = New-Object 'System.Windows.Forms.TextBox'
	$label2 = New-Object 'System.Windows.Forms.Label'
	$labelWindowsAccount = New-Object 'System.Windows.Forms.Label'
	$WindowsUsername = New-Object 'System.Windows.Forms.TextBox'
	$buttonOK = New-Object 'System.Windows.Forms.Button'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$formConfiguration_Load={
		#TODO: Initialize Form Controls here
		$WindowsUsername.Text = $global:adminUser
		$cpelsEmail.Text = $global:cpelsEmail
		$cpelspasword.Text = $global:cpelsSerial
	}
	
	$buttonOK_Click = {
		
		$reply = $cpelsService.CloudUser($cpelsEmail.Text, $cpelspasword.Text)
		if ($reply[0] -ne "error")
		{
			Set-ItemProperty -Path $RegistryLocation -Name cpelsEmail -Value $cpelsEmail.Text
			Set-ItemProperty -Path $RegistryLocation -Name cpelsSerial -Value $cpelspasword.Text
			$global:cpelsEmail = $cpelsEmail.Text
			$global:cpelsSerial = $cpelspasword.Text
			$ServerDnsName.Text = $reply[2]
			$ServerDnsName.Visible = $true
			$labelYourServerName.Visible = $true
			[System.Windows.Forms.MessageBox]::Show("Your cpelsEmail and or serial is correct, your new server will use public certicates")
		}
		else
		{
			Set-ItemProperty -Path $RegistryLocation -Name cpelsEmail -Value "none"
			Set-ItemProperty -Path $RegistryLocation -Name cpelsSerial -Value "none"
			$global:cpelsEmail = "none"
			$global:cpelsSerial = "none"
			[System.Windows.Forms.MessageBox]::Show("Your cpelsEmail and or serial is not correct, will switch to self signed certificate usage")
			$ServerDnsName.Text = ""
			$ServerDnsName.Visible = $False
			$labelYourServerName.Visible = $False
		}
		
		Set-ItemProperty -Path $RegistryLocation -Name adminuser -Value $WindowsUsername.Text
	
		$global:adminUser = $WindowsUsername.Text
		
		$formConfiguration.Close
	}
	
	
	
	
	$labelCpelsDesktopAccount_Click={
		#TODO: Place custom script here
		
	}
	
	$labelCpelsDesktopAccount_Click={
		#TODO: Place custom script here
		
	}
	
	$labelCpelsDesktopAccount_Click={
		#TODO: Place custom script here
		
	}
		# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formConfiguration.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
		$script:ConfigurationScreen_cpelspasword = $cpelspasword.Text
		$script:ConfigurationScreen_cpelsEmail = $cpelsEmail.Text
		$script:ConfigurationScreen_WindowsUsername = $WindowsUsername.Text
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$labelCpelsDesktopAccount.remove_Click($labelCpelsDesktopAccount_Click)
			$buttonOK.remove_Click($buttonOK_Click)
			$formConfiguration.remove_Load($formConfiguration_Load)
			$formConfiguration.remove_Load($Form_StateCorrection_Load)
			$formConfiguration.remove_Closing($Form_StoreValues_Closing)
			$formConfiguration.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch [Exception]
		{ }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formConfiguration.SuspendLayout()
	#
	# formConfiguration
	#
	$formConfiguration.Controls.Add($labelSerial)
	$formConfiguration.Controls.Add($labelEmail)
	$formConfiguration.Controls.Add($labelCpelsDesktopAccount)
	$formConfiguration.Controls.Add($cpelspasword)
	$formConfiguration.Controls.Add($cpelsEmail)
	$formConfiguration.Controls.Add($label2)
	$formConfiguration.Controls.Add($labelWindowsAccount)
	$formConfiguration.Controls.Add($WindowsUsername)
	$formConfiguration.Controls.Add($buttonOK)
	$formConfiguration.AcceptButton = $buttonOK
	$formConfiguration.ClientSize = '284, 262'
	$formConfiguration.FormBorderStyle = 'FixedDialog'
	$formConfiguration.MaximizeBox = $False
	$formConfiguration.MinimizeBox = $False
	$formConfiguration.Name = 'formConfiguration'
	$formConfiguration.StartPosition = 'CenterScreen'
	$formConfiguration.Text = 'Configuration'
	$formConfiguration.add_Load($formConfiguration_Load)
	#
	# labelSerial
	#
	$labelSerial.Location = '54, 149'
	$labelSerial.Name = 'labelSerial'
	$labelSerial.Size = '57, 23'
	$labelSerial.TabIndex = 15
	$labelSerial.Text = 'Serial:'
	#
	# labelEmail
	#
	$labelEmail.Location = '52, 124'
	$labelEmail.Name = 'labelEmail'
	$labelEmail.Size = '57, 23'
	$labelEmail.TabIndex = 14
	$labelEmail.Text = 'Email:'
	#
	# labelCpelsDesktopAccount
	#
	$labelCpelsDesktopAccount.Location = '15, 94'
	$labelCpelsDesktopAccount.Name = 'labelCpelsDesktopAccount'
	$labelCpelsDesktopAccount.Size = '124, 23'
	$labelCpelsDesktopAccount.TabIndex = 13
	$labelCpelsDesktopAccount.Text = 'Cpels desktop account'
	$labelCpelsDesktopAccount.add_Click($labelCpelsDesktopAccount_Click)
	#
	# cpelspasword
	#
	$cpelspasword.Location = '120, 146'
	$cpelspasword.Name = 'cpelspasword'
	$cpelspasword.PasswordChar = '*'
	$cpelspasword.Size = '149, 20'
	$cpelspasword.TabIndex = 12
	#
	# cpelsEmail
	#
	$cpelsEmail.Location = '120, 120'
	$cpelsEmail.Name = 'cpelsEmail'
	$cpelsEmail.Size = '149, 20'
	$cpelsEmail.TabIndex = 11
	#
	# label2
	#
	$label2.Location = '50, 45'
	$label2.Name = 'label2'
	$label2.Size = '57, 23'
	$label2.TabIndex = 9
	$label2.Text = 'Username'
	#
	# labelWindowsAccount
	#
	$labelWindowsAccount.Location = '13, 20'
	$labelWindowsAccount.Name = 'labelWindowsAccount'
	$labelWindowsAccount.Size = '104, 23'
	$labelWindowsAccount.TabIndex = 8
	$labelWindowsAccount.Text = 'Windows Account'
	#
	# WindowsUsername
	#
	$WindowsUsername.Location = '118, 41'
	$WindowsUsername.Name = 'WindowsUsername'
	$WindowsUsername.Size = '149, 20'
	$WindowsUsername.TabIndex = 1
	#
	# buttonOK
	#
	$buttonOK.Anchor = 'Bottom, Right'
	$buttonOK.DialogResult = 'OK'
	$buttonOK.Location = '197, 227'
	$buttonOK.Name = 'buttonOK'
	$buttonOK.Size = '75, 23'
	$buttonOK.TabIndex = 0
	$buttonOK.Text = '&OK'
	$buttonOK.UseVisualStyleBackColor = $True
	$buttonOK.add_Click($buttonOK_Click)
	$formConfiguration.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formConfiguration.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formConfiguration.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formConfiguration.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$formConfiguration.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $formConfiguration.ShowDialog()

}
#endregion Source: ConfigurationScreen.psf

#region Source: about.psf
function Call-about_psf
{

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Xml, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.DirectoryServices, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.ServiceProcess, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formAbout = New-Object 'System.Windows.Forms.Form'
	$labelHttpsnllinkedincompu = New-Object 'System.Windows.Forms.Label'
	$buttonClose = New-Object 'System.Windows.Forms.Button'
	$labelVersion11 = New-Object 'System.Windows.Forms.Label'
	$labelYourAzureCloudDeskto = New-Object 'System.Windows.Forms.Label'
	$labelMadeByCharlPels = New-Object 'System.Windows.Forms.Label'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	$formAbout_Load={
		#TODO: Initialize Form Controls here
		
	}
	
	$formAbout_Load={
		#TODO: Place custom script here
		
	}
	
	$buttonClose_Click={
		#TODO: Place custom script here
		$formabout.Close()
	}
	
	
	
	$labelHttpsnllinkedincompu_Click={
		Start-Process  "https://nl.linkedin.com/pub/charl-pels/30/510/406"
	}
		# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formAbout.WindowState = $InitialFormWindowState
	}
	
	$Form_StoreValues_Closing=
	{
		#Store the control values
	}

	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$labelHttpsnllinkedincompu.remove_Click($labelHttpsnllinkedincompu_Click)
			$buttonClose.remove_Click($buttonClose_Click)
			$formAbout.remove_Load($formAbout_Load)
			$formAbout.remove_Load($Form_StateCorrection_Load)
			$formAbout.remove_Closing($Form_StoreValues_Closing)
			$formAbout.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch [Exception]
		{ }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formAbout.SuspendLayout()
	#
	# formAbout
	#
	$formAbout.Controls.Add($labelHttpsnllinkedincompu)
	$formAbout.Controls.Add($buttonClose)
	$formAbout.Controls.Add($labelVersion11)
	$formAbout.Controls.Add($labelYourAzureCloudDeskto)
	$formAbout.Controls.Add($labelMadeByCharlPels)
	$formAbout.ClientSize = '284, 261'
	$formAbout.Name = 'formAbout'
	$formAbout.Text = 'About'
	$formAbout.add_Load($formAbout_Load)
	#
	# labelHttpsnllinkedincompu
	#
	$labelHttpsnllinkedincompu.Location = '12, 145'
	$labelHttpsnllinkedincompu.Name = 'labelHttpsnllinkedincompu'
	$labelHttpsnllinkedincompu.Size = '260, 21'
	$labelHttpsnllinkedincompu.TabIndex = 4
	$labelHttpsnllinkedincompu.Text = 'https://nl.linkedin.com/pub/charl-pels/30/510/406'
	$labelHttpsnllinkedincompu.add_Click($labelHttpsnllinkedincompu_Click)
	#
	# buttonClose
	#
	$buttonClose.Location = '197, 226'
	$buttonClose.Name = 'buttonClose'
	$buttonClose.Size = '75, 23'
	$buttonClose.TabIndex = 3
	$buttonClose.Text = 'Close'
	$buttonClose.UseVisualStyleBackColor = $True
	$buttonClose.add_Click($buttonClose_Click)
	#
	# labelVersion11
	#
	$labelVersion11.Location = '96, 63'
	$labelVersion11.Name = 'labelVersion11'
	$labelVersion11.Size = '65, 23'
	$labelVersion11.TabIndex = 2
	$labelVersion11.Text = 'version 1.1'
	#
	# labelYourAzureCloudDeskto
	#
	$labelYourAzureCloudDeskto.Font = 'Microsoft Sans Serif, 14.25pt, style=Bold'
	$labelYourAzureCloudDeskto.Location = '12, 21'
	$labelYourAzureCloudDeskto.Name = 'labelYourAzureCloudDeskto'
	$labelYourAzureCloudDeskto.Size = '260, 23'
	$labelYourAzureCloudDeskto.TabIndex = 1
	$labelYourAzureCloudDeskto.Text = 'Your Azure cloud desktop'
	#
	# labelMadeByCharlPels
	#
	$labelMadeByCharlPels.Location = '72, 123'
	$labelMadeByCharlPels.Name = 'labelMadeByCharlPels'
	$labelMadeByCharlPels.Size = '110, 22'
	$labelMadeByCharlPels.TabIndex = 0
	$labelMadeByCharlPels.Text = 'Made by Charl Pels'
	$formAbout.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formAbout.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formAbout.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formAbout.add_FormClosed($Form_Cleanup_FormClosed)
	#Store the control values when form is closing
	$formAbout.add_Closing($Form_StoreValues_Closing)
	#Show the Form
	return $formAbout.ShowDialog()

}
#endregion Source: about.psf

#Start the application
Main ($CommandLine)
