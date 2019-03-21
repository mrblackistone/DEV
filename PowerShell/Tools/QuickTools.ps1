$Commands = @()
 
Function Get-AzureRMRoles {
 
    param (
        $searchText
    )
    Get-AzureRMRoleDefinition | Where-Object actions -like "*$searchText*" | ForEach-Object { write-host; $_.Name; $_.Actions }
}
 
Function Get-Password {
    param (
	    [switch]$special,
	    [int]$maxLength = 12
    )
        
    If ($special) {
	    $source = @(1,2,3,4,5,6,7,8,9,0,"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m",".","-","_","!","#","^","~")
    } else {
	    $source = @(1,2,3,4,5,6,7,8,9,0,"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m")
    }
 
    [int]$location = 0
    [string]$result = ""
 
    Do {
	    $number = get-random -maximum ($source.count - 1)
	    $result = $result + $source[$number]
	    $location++
    } until ($location -ge $maxlength)
 
    write-host "Your randomly-generated string is:" $result
}
 
Function Get-AzureRMVnetID {
    param (
        [string][parameter(mandatory=$true)]$vnetName
    )
    (Get-azurermvirtualnetwork | Where-Object name -eq $vnetName).id 
}
 
Function Convert-FQDNtoDN {
    param (
	[Parameter(mandatory=$true)]$FQDN
    )
 
    $DN = ""
    $FQDNArray = $FQDN.split(".")
    $Separator = ","
 
    for ($x = 0; $x -lt $FQDNArray.Length ; $x++) { 
        If ($x -eq ($FQDNArray.Length - 1)) {[string]$DN += "DC=" + $FQDNArray[$x]}
        ElseIf ($x -eq ($FQDNArray.Length - 2)) {[string]$DN += "DC=" + $FQDNArray[$x] + ","}
        Else {[string]$DN += "OU=" + $FQDNArray[$x] + ","}
    }
    Write-Host $DN
}
 
function Get-AzureRMPrivateIPs {
    param (
        $ResourceGroupName
    )
    If ($resourceGroupName -eq $null) {
        (Get-AzureRMNetworkInterface | Get-AzureRMNetworkInterfaceIPConfig).PrivateIpAddress
    } else {
        (Get-AzureRMNetworkInterface -ResourceGroupName $resourceGroupName | Get-AzureRMNetworkInterfaceIPConfig).PrivateIpAddress
    }
}
 
function SetCurrent-Subscription {
    param (
        [switch]$Test,
        [switch]$Core
    )
    If ($test) {Select-AzureRmSubscription -Subscription insertsubidhere }
    If ($core) {Select-AzureRmSubscription -Subscription insertothersubidhere }
}
 
function Open-Tools {
    & "C:\Program Files\Microsoft VS Code\Code.exe"
    & "C:\Program Files (x86)\Microsoft Office\Office16\OUTLOOK.EXE"
    & "C:\Program Files (x86)\Microsoft Office\Office16\WINWORD.EXE"
    & "C:\Program Files (x86)\Microsoft Office\Office16\ONENOTE.EXE"
}
 
##########################################################################
Function List-Commands {
    $inputCommandDescriptions = [ordered]@{
        "Get-Password"                 = "Generates a password"
        "Get-AzureRMRoles"             = "Lists all roles containing a provided permission path"
        "Get-AzureRMVnetID"            = "Gets the vNet ID of a vNet by name"
        "Convert-FQDNtoDN"             = "Converts an FQDN path to an AD DN"
        "Get-AzureRMPrivateIPs"        = "Lists private IPs that are in use, and allows you to specify an RG"
        "SetCurrent-Subscription"      = "Sets the current subscription to Test or Core"
        "Open-Tools"                   = "Opens common desktop tools"
        "List-Commands"                = "Lists these commands"
    }
    $myArray = @()
    $inputCommandDescriptions.Keys | ForEach-Object { $myArray += [PSCustomObject]@{Command = $_;Description=$inputCommandDescriptions.Item($_)} }
    $myArray
}
 
List-Commands

