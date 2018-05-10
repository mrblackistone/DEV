param (
    $location
)

# 1.  The purpose of this script is to go through all JSON files in your current folder and subfolders,
#     then look up their resources' types, find the most recent available API version online, and update
#     the API version in the JSON to the newest, and finally write the change to the file(s).
# 2.  A hash table is used as API versions are looked up to avoid redundant/repeated lookups which
#     would slow down the script significantly.
# 3.  A log file is created with all of the files modified, their resources' original API values, and their new API values.

$ErrorActionPreference = 'SilentlyContinue'

Write-Host  "You about about to update the API version of all resources in ALL JSON files in the current folder and ALL sub-folders.  Are you absolutely sure you want to proceed (y/n)?" -ForegroundColor Black -BackgroundColor Yellow
$confirmation = Read-Host
if ($confirmation -ne 'y') {exit}
Write-Output "" | Tee-Object .\JsonApiReplaceLog.txt

$newestApiVersions = @{}
Get-ChildItem -Filter *.json -Recurse | ForEach-Object {
    Write-Output "" | Tee-Object .\JsonApiReplaceLog.txt -Append
    $log = "Current file is "+$_.FullName
    Write-Output $log | Tee-Object .\JsonApiReplaceLog.txt -Append
    $inputJson = Get-Content $_.FullName | Out-String
    $jsonObject = ConvertFrom-Json -InputObject ($inputJson)
    $jsonObject.resources | ForEach-Object {
        $log = "Changing resource "+$_.name+" of type "+$_.type+" and version "+$_.apiVersion
        Write-Output $log | Tee-Object .\JsonApiReplaceLog.txt -Append
        if ($newestApiVersions.ContainsKey($_.Type) -eq $true) {
            $_.apiVersion = $newestApiVersions[$_.type]
        } else {
            $providerNamespace = $_.type.split("/",2)[0]
            $resourceTypeName = $_.type.split("/",2)[1]
            $thisObjectNewestVersion = ((Get-AzureRMResourceProvider -Location $location -ProviderNamespace $providerNamespace).ResourceTypes | Where-Object ResourceTypeName -eq $resourceTypeName).ApiVersions[0]
            if ($thisObjectNewestVersion -ne $null) {
                $newestApiVersions += @{$_.type = $thisObjectNewestVersion}
                $_.apiVersion = $newestApiVersions[$_.type]
            }
        }
        $log = "...to version "+$_.apiVersion
        Write-Output $log | Tee-Object .\JsonApiReplaceLog.txt -Append
    } -Verbose
    $FormatConvert = ConvertTo-JSON -InputObject $jsonObject -Depth 99
    $FormatConvert = $FormatConvert.Replace("\u0027","`'") | Out-File $_.FullName
    $log = "Updating file "+$_.FullName
    Write-Output $log | Tee-Object .\JsonApiReplaceLog.txt -Append
} -ErrorAction Continue
