param (
    $computername,
    $IPAddress,
    $Zone
)

Add-DnsServerResourceRecordA -Name $computername -ZoneName $Zone -IPv4Address 25.0.0.5