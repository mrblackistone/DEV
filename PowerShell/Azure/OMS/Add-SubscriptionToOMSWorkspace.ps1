param (
    $resourceGroupName,
    $workspaceName,
    $subscriptionIdToLink,
    $subscriptionNameForOMS
)

#This script links an existing subscription's AzureActivityLogs to an existing OMS workspace

#Login-AzureRmAccount
Select-AzureRmSubscription -Subscription $subscriptionNameForOMS
$omsWorkspace = Get-AzureRmOperationalInsightsWorkspace -Name $workspaceName -ResourceGroupName $resourceGroupName

# If you want to view the current data sources
# $dataSources = Get-AzureRmOperationalInsightsDataSource -WorkspaceName $workspaceName -ResourceGroupName $resourceGroupName -Kind AzureActivityLog

#We name the link the same as the subscriptionId, but you could also use a GUID, random string, etc.
New-AzureRmOperationalInsightsAzureActivityLogDataSource -Workspace $omsWorkspace -Name $subscriptionIdToLink -SubscriptionId $subscriptionIdToLink 

