$Url1 = "https://api-gateway.boats.com/api-yachtworld/search?apikey=827d6e453fef4ce390afe017b5a7db4b&uom=ft&locale=en_US&currency=USD&length=0-101&"
$Url2 = "&isMultiSearch=true&fields=make,model,year,boat.specifications.dimensions.lengths.nominal,price.type.amount,price.discount"
$page = 1
$fullUrl = "$($Url1)page=$page$($Url2)"

$listing = Invoke-WebRequest -Uri $fullUrl
$json = ConvertFrom-Json -InputObject $listing.Content
$totalPages = $json.search.lastPage

#$outputs = [System.Collections.ArrayList]@()
Set-Content -Value "Make`tModel`tYear`tLength`tPrice" -Path "c:\temp\boatprices.csv"

for ($page=1;$page -le $totalPages;$page++) {
    Start-Sleep 3
    $fullUrl = "$($Url1)page=$page$($Url2)"
    if ($page%20 -eq 0) { Write-Output "Now on page $page" }
    try {
        $listing = Invoke-WebRequest -Uri $fullUrl
    }
    catch {
        start-sleep 15
        $listing = Invoke-WebRequest -Uri $fullUrl
    }
    $json = ConvertFrom-Json -InputObject $listing.Content
    foreach ($result in $json.search.records) {
        Add-Content -Path "C:\temp\boatprices.csv" -Value "$($result.Make)`t$($result.Model)`t$($result.Year)`t$($result.boat.specifications.dimensions.lengths.nominal.ft)`t$($result.price.type.amount.USD)"
#        $object = [PSCustomObject]@{
#            "Make" = $result.make
#            "Model" = $result.model
#            "Year" = $result.year
#            "Length" = $result.boat.specifications.dimensions.lengths.nominal.ft
#            "Price" = $result.price.type.amount.USD
#        }
#        Out-Null -InputObject $outputs.Add($object)
    }
}

<#
foreach ($output in $outputs) {
    Add-Content -Path "C:\temp\boatprices.csv" -Value "$($output.Make)`t$($output.Model)`t$($output.Year)`t$($output.Length)`t$($output.Price)"
}
#>