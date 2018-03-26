param (
    [parameter(mandatory=$true)][string]$AddOrRemove,
    [parameter(mandatory=$true)][string]$ResourceGroupToLock,
    [parameter(mandatory=$true)][string]$SubscriptionID
)

##This script adds or removes individual resource locks from all resources in a given subscription and resource group.
#Login-AzureRMAccount -Environment azureusgovernment
#Get-AzureRMSubscription
Select-AzureRmSubscription -Subscription $SubscriptionID

if ($AddOrRemove -eq "Add") {
    $res = get-azurermresource | Where-Object {$_.ResourceGroupName -eq $ResourceGroupToLock }
    $res | ForEach-Object {
        $name = $_.Name + "DeleteLock"
        New-AzureRMResourceLock -LockLevel CanNotDelete -LockName $name -ResourceName $_.ResourceName -ResourceType $_.ResourceType -ResourceGroupName $_.ResourceGroupName -Force
    }
} elseif ($AddOrRemove -eq "Remove" ) {
    $res = get-azurermresource | Where-Object {$_.ResourceGroupName -eq $ResourceGroupToLock }
    $res | ForEach-Object {
        $lockId = (Get-AzureRmResourceLock -ResourceGroupName $_.ResourceGroupName -ResourceName $_.ResourceName -ResourceType $_.ResourceType).LockId
        Remove-AzureRmResourceLock -LockId $lockId -Force
    }
} else { throw "Invalid value provided for parameter AddOrRemove.  You must specify Add to add resource locks or Remove to remove them." } 

