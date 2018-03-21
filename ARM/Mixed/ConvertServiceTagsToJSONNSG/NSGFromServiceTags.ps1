# 1. Takes an input file, ServiceTags.json, and pulls the Azure Government IP ranges for storage in all of its regions.
# 2. Creates rules as PSCustomObjects
# 3. Imports the DynamicNSG.json file, adds the newly-created rules, then exports the new JSON as GovStorageNSG.json

param (
    [parameter(mandatory=$true,HelpMessage="The priority of the first rule to be created. Others will be incremented from this.")][int]$priority = 500,
    [parameter(HelpMessage="The maximum number of rules allowed to be generated.")][int]$maxrules = 100
)

$InputJSON = Get-Content .\ServiceTags_20180319.json -ErrorAction Stop | Out-String
$InputJsonObj = ConvertFrom-JSON -InputObject ($InputJSON)
$CIDRObjects = ($inputjsonobj.values | Where-object -Property Name -in @('Storage.USGovArizona','Storage.USGovIowa','Storage.USGovTexas','Storage.USGovVirginia','Storage.USGovWyoming')).properties | Foreach-object {
    $name = $_.region
    $_.addressprefixes | ForEach-object {
        [pscustomobject]@{
            Name = $name
            Range = $_
        }
    }
}


#We now have $CIDRObjects, which is an array of objects, each of which has a Name (the datacenter) and a Range.

if ($CIDRObjects.Count -gt ($maxrules/2)) { throw "Number of rules generated exceeds the maximum parameter of $maxrules." }

$list = $CIDRObjects | ForEach-Object {
    $Datacenter = $_.Name
    $Destination = $_.Range
    '80', '443' | ForEach-Object {
        [PSCustomOBject]@{
            Name       = "$Datacenter-$Priority-$_"
            Properties = @{
                description              = "Allows TCP Port $_ out to storage in the $Destination range within the $Datacenter datacenter"
                protocol                 = 'TCP'
                sourcePortRange          = '*'
                destinationPortRange     = $_
                sourceAddressPrefix      = '*'
                destinationAddressPrefix = $Destination
                access                   = 'Allow'
                priority                 = $Priority
                direction                = 'Outbound'
            }
        }
        $priority++
    }
}

$JSON = Get-Content .\DynamicNSG.json | Out-String
$JsonObj = ConvertFrom-JSON -InputObject ($JSON)

$JsonObj.resources.properties.SecurityRules += $list

ConvertTo-JSON -InputObject $JsonObj -Depth 99 | Out-File .\GovStorageNSG.json

#For testing purposes:
#notepad .\GovStorageNSG.json