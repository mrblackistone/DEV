param (
    $pwd = 'TestPasswword1!'
)

[Securestring]$pspassword = $pwd | ConvertTo-SecureString -AsPlainText -Force

# Above, we have converted plaintext string in variable $pwd to a SecureString in variable $pspassword.
#
# Below, we create a new PSCredential object with the same password as that contained in $pspassword, 
# but we reveal the password of this new object in plaintext.
 
(New-Object System.Management.Automation.PSCredential ('N/A', $pspassword)).GetNetworkCredential().Password
