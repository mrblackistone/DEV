param (
    [parameter(mandatory=$true,ParameterSetName="Commercial")]
    [Switch]$Commercial,
    [parameter(mandatory=$true,ParameterSetName="Government")]
    [Switch]$Government
)

# Download File containing most recent published list of Azure Government IP ranges
if ($commercial) { $downloadUri = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=56519" }
if ($government) { $downloadUri = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=57063" }
$downloadPage = Invoke-WebRequest -Uri $downloadUri
if ($commercial) { $jsonFileUri = ($downloadPage.RawContent.Split('"') -like "https://*servicetags*public*.json")[0] }
if ($government) { $jsonFileUri = ($downloadPage.RawContent.Split('"') -like "https://*servicetags*azuregovernment*.json")[0] }
$response = Invoke-WebRequest -Uri $jsonFileUri
$position = $response.RawContent.IndexOf('{')
$InputJSON = $response.RawContent.Substring($position)
$InputJsonObj = ConvertFrom-JSON -InputObject ($InputJSON)

# Create the $unfilteredRanges array, which contains all of the Azure IP ranges as strings.
$unfilteredRanges = @()
#$inputJsonObj.values | ForEach-Object { $unfilteredRanges += $_.properties.addressprefixes }
$unfilteredRanges = $InputJsonObj.values.properties.addressprefixes | Sort-Object { ($_.split("/")[1]).toInt32($null) }

# Remove duplicate entries
$filteredRanges = @()
$unfilteredRanges | ForEach-Object {
    if ($_ -notin $filteredRanges) {$filteredRanges += $_}
}

# Convert each CIDR-notated subnet range into binary to compare network IDs to eliminate overlaps, 
# favoring less restrictive (shorter) net masks.
$rangeObjects = @()
$filteredRanges | ForEach-Object {
    $ip = $_.split('/')[0]
    $mask = $_.split('/')[1]
    $octets = $ip -split "\." 
    #Split IP into different octects and for each one, figure out the binary with leading zeros and add to the total
    $ipInBinary = @() 
    foreach ($octet in $octets) {
        #Convert to binary
        $octetInBinary = [convert]::ToString($octet, 2)
        #Get length of binary string add leading zeros to make octet
        $octetInBinary = ("0" * (8 - ($octetInBinary).Length) + $octetInBinary)
        $ipInBinary = $ipInBinary + $octetInBinary
    }
    $ipInBinary = $ipInBinary -join ""
    #Get network ID by subtracting subnet mask 
    $networkIdInBinary = $ipInBinary.Substring(0, $mask) 
    
    $rangeObjects += [PSCustomObject]@{
        IP                = [String]$ip
        Mask              = [Int]$mask
        NetworkIdInBinary = [String]$networkIdInBinary
    }
}

# Identify overlapping ranges and eliminate the ones with more restrictive (longer) netmasks.  Requires that the
# input array be sorted in order from lowest to highest netmask (e.g. 16 to 32), which was accomplished earlier.
$finalizedListOfRangeObjects = @()
$finalizedListOfRangeObjects += $rangeObjects[0]
for ($a=1;$a -lt $rangeObjects.count;$a++) {
    $comparison = $rangeObjects[$a]
    $conflictBoolean = $false
    foreach ($finalObject in $finalizedListOfRangeObjects) {
        if ($comparison.NetworkIdInBinary.StartsWith($finalObject.NetworkIdInBinary)) {
            $conflictBoolean = $true
            continue
        }
    }
    if ($conflictBoolean -eq $false) {$finalizedListOfRangeObjects += $comparison}
}

# Go through the finalized list of non-conflicting objects and add them as CIDR-notated subnets to a single string
# for use in an NSG rule via the Azure portal.
[String]$finalStringListForPortal = ""
$endIndex = $finalizedListOfRangeObjects.Count-2
$finalizedListOfRangeObjects[0..$endIndex] | ForEach-Object {
    $finalStringListForPortal += $_.ip,"/",$_.mask,","
}
$finalStringListForPortal += $finalizedListOfRangeObjects[-1].IP,"/",$finalizedListOfRangeObjects[-1].Mask
$finalStringListForPortal = $finalStringListForPortal.Replace(' ','')

# Generate another variable formatted for use in an ARM template.
$finalStringListForArmTemplate = $finalStringListForPortal.Replace(',',",`n")
Write-Output 'Use the variable $finalStringListForPortal to obtain the ranges formatted for use in the Azure Portal.'
Write-Output 'Use the variable $finalStringListForArmTemplate to obtain the ranges formatted for use in an ARM template.  This would go in the sourceAddressPrefixes or destinationAddressPrefixes property, depending on if the rule is inbound or outbound respectively.'
Write-Output 'If there are too many ranges, you may need to break up the output into more than one NSG rule.'

# We now have $finalStringListForPortal, which can be used to create the rule with all ranges in the single rule.
# We also now have $finalStringListForArmTemplate, which can be added to a rule configuration in an ARM template.
