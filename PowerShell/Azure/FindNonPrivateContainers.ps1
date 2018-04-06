param(
    [Parameter(Mandatory=$true)]$username,
    [Parameter(Mandatory=$true)]$password,
    $tenantId
)

#Finds all storage containers which are not set to private within all accessible subscriptions.  Requires use of a service principal with read access to storage account keys.

[securestring]$securePassword = $Password | ConvertTo-SecureString -asplaintext -force
$PSCredential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

Add-AzureRmAccount -Credential $PSCredential -TenantId $tenantId -ServicePrincipal -Environment azureusgovernment

$finalresult = 0
$AvailableSubscriptions = Get-AzureRMSubscription
Write-Host "Current subscriptions are:"
$AvailableSubscriptions | ForEach-Object {
    Write-Host $_.Name
}

$AvailableSubscriptions | ForEach-Object {
    Select-AzureRmSubscription -subscription $_.SubscriptionId
    Write-Host "Current subscription is " $_.Name
    $StorageAccounts = Get-AzureRMStorageAccount
    $result = @()

    $StorageAccounts | ForEach-Object {
        $key1 = (Get-AzureRmStorageAccountKey -ResourceGroupName $_.ResourceGroupName -name $_.StorageAccountName)[0].value
        $context = New-AzureStorageContext -StorageAccountName $_.StorageAccountName -StorageAccountKey $key1
        $result += Get-AzureStorageContainer -Context $context | Where-object PublicAccess -ne "Off"
        #Get-AzureStorageBlob -Context $context -Container myContainer
    }

    $SubscriptionName = $_.Name

    if ($result.count -eq 0) {
        Write-Host "All storage containers in subscription $SubscriptionName are set to private."
    } else {
        Write-Warning "The following containers in subscription $SubscriptionName are not set to private:"
        $result
        $finalresult += $result.count
    }
}

if ($finalresult -ne 0) { 
    Write-Warning "Number of non-compliant containers found: $finalresult"
    throw "Please review non-private containers and correct as necessary." 
}