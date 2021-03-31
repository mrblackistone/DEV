$URI1 = "https://api.landsearch.com/v1/listings?paginate=true&"
$URI2 = "&sort=-size&buffer=true&structure=0"
$page = 1
$fullUri = "$($URI1)page=$page$($URI2)"

$listing = Invoke-WebRequest -Uri $fullUri
$json = ConvertFrom-Json -InputObject $listing.Content
$totalPages = $json.total_pages

$output = [System.Collections.ArrayList]@()

for ($page=1;$page -le $totalPages;$page++) {
    $fullUri = "$($URI1)page=$page$($URI2)"
    $listing = Invoke-WebRequest -Uri $fullUri
    $json = ConvertFrom-Json -InputObject $listing.Content
    foreach ($result in $json.results) {
        $object = @{}
        $output.Add($object)
    }
}



