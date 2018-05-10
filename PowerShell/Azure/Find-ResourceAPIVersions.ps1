param (
    $location
)
#The purpose of this script is to go through all of the resources you have access to across all of your Azure environment's subscriptions, 
#and provide the two most recent available API versions for their respective provider namespaces and resource types.

Get-azurermsubscription | ForEach-Object {
    Select-AzureRmSubscription -Subscription $_.SubscriptionId
    Get-AzureRmResource | ForEach-Object {
        [string]$resourceType = $_.ResourceType
        if ($resourceType -notin $a) {$a += $resourceType}
    }
}

$a | ForEach-Object {
    $providerNamespace = $_.split("/",2)[0]
    $resourceTypeName = $_.split("/",2)[1]
    Write-Host $_":";
    ((Get-AzureRMResourceProvider -Location $location -ProviderNamespace $providerNamespace).ResourceTypes | Where-Object ResourceTypeName -eq $resourceTypeName).ApiVersions[0,1];"";
}
