param (
    $key,
    $containerName,
    $storageAccount
)

# Cleans all blobs from the specified container in the target storage account.

$storageContext = New-AzureStorageContext -StorageAccountName $storageAccount -StorageAccountKey $key
$Blobs = Get-AzureStorageBlob -Container $containerName -Context $storageContext
ForEach ($blob in $blobs) {
    Remove-AzureStorageBlob -Blob $blob.Name -Context $storageContext -Container $containerName
}
