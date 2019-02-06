Login-AzAccount

$spDisplayName = 'miblacki-aztest2'
$servicePrincipal = New-AzADServicePrincipal -DisplayName $spDisplayName #-Password $securePassword
$servicePrincipal.Secret

$pwdPlain = (New-Object System.Management.Automation.PSCredential ('N/A', $servicePrincipal.Secret)).GetNetworkCredential().Password

Write-Warning "The password is: $pwdPlain (WRITE THIS DOWN)"

