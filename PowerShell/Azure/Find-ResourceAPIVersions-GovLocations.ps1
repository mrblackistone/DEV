
#The purpose of this script is to go through all of the resources you have access to across all of your Azure environment's subscriptions, 
#and provide the two most recent available API versions in each USGOV datacenter for their respective provider namespaces and resource types.

$erroractionpreference = 'SilentlyContinue'
$a = @()
Get-azurermsubscription | ForEach-Object {
    Select-AzureRmSubscription -Subscription $_.SubscriptionId
    Get-AzureRmResource | ForEach-Object {
        [string]$resourceType = $_.ResourceType
        if ($resourceType -notin $a) {$a += $resourceType}
    }
}

#$datacenters = @('USGovArizona','USGovIowa','USGovTexas','USGovVirginia','USGovWyoming')
$datacenters = @('USGovArizona','USGovIowa','USGovTexas','USGovVirginia')
$outputList = $datacenters | ForEach-Object {
    $currentDatacenter = $_
    $a | ForEach-Object {
        $providerNamespace = $_.split("/",2)[0]
        $resourceTypeName = $_.split("/",2)[1]
        $first = $null
        $second = $null
        $first = ((Get-AzureRMResourceProvider -Location $currentDatacenter -ProviderNamespace $providerNamespace).ResourceTypes | Where-Object ResourceTypeName -eq $resourceTypeName).ApiVersions[0]
        $second = ((Get-AzureRMResourceProvider -Location $currentDatacenter -ProviderNamespace $providerNamespace).ResourceTypes | Where-Object ResourceTypeName -eq $resourceTypeName).ApiVersions[1]
        Write-Host "Using" $currentDatacenter $providerNamespace $resourceTypeName "first:" $first "second:" $second
        if ( $first -ne $null ) {
            if ( $second -eq $null ) { $second = "n/a" }
            [PSCustomObject]@{
                Datacenter = $currentDatacenter
                ResourceType = $_
                MostRecentAPIVersion = $first
                SecondRecentAPIVersion = $second
            }
        }
    }
}

$outputList | Sort-Object -Property Datacenter,ResourceType | Format-Table
