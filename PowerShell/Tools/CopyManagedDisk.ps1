param (
    $subscriptionID
)

Login-AzureRMAccount -Environment azureusgovernment
Get-AzureRMSubscription
Select-AzureRmSubscription -Subscription $subscriptionID


#Provide the subscription Id of the subscription where managed disk exists
$sourceSubscriptionId=$subscriptionID

#Provide the name of your resource group where managed disk exists
$sourceResourceGroupName='mrbTest'

#Provide the name of the managed disk
$managedDiskName='mrbFP0_OsDisk_1_d8fd57339b7d4121a806130e607f7ff3b'

#Set the context to the subscription Id where Managed Disk exists
Select-AzureRmSubscription -SubscriptionId $sourceSubscriptionId

#Get the source managed disk
$managedDisk= Get-AzureRMDisk -ResourceGroupName $sourceResourceGroupName -DiskName $managedDiskName

#Provide the subscription Id of the subscription where managed disk will be copied to
#If managed disk is copied to the same subscription then you can skip this step
$targetSubscriptionId=$subscriptionID

#Name of the resource group where snapshot will be copied to
$targetResourceGroupName='mrbTest'

#Set the context to the subscription Id where managed disk will be copied to
#If snapshot is copied to the same subscription then you can skip this step
Select-AzureRmSubscription -SubscriptionId $targetSubscriptionId

$diskConfig = New-AzureRmDiskConfig -SourceResourceId $managedDisk.Id -Location $managedDisk.Location -CreateOption Copy 

#Create a new managed disk in the target subscription and resource group
$targetmanagedDiskName = $managedDiskName + "_backup"
New-AzureRmDisk -Disk $diskConfig -DiskName $targetmanagedDiskName -ResourceGroupName $targetResourceGroupName