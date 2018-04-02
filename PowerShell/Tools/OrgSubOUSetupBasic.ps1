param(
    [Parameter(Mandatory=$true)]$OrgName
)

$OUAdmins = "$OrgName-OU-Admins"
$AzureAdmins = "$OrgName-Azure-Admins"
$Users = "$OrgName-Users"
$ParentOU = "OU=Orgs,DC=TestOrg,DC=local"

$OrgPath = "OU=$OrgName,$ParentOU"

#Set up OU structure
New-ADOrganizationalUnit -Name $Orgname -Path "$ParentOU" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name Computers -Path $OrgPath -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name Groups -Path $OrgPath -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name ServiceAccounts -Path $OrgPath -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name Users -Path $OrgPath -ProtectedFromAccidentalDeletion $false

#Set up groups
New-ADGroup -Name $OUAdmins -path "OU=Groups,$OrgPath" -Description "OU Administrators for the $Orgname OU" -GroupScope Global
New-ADGroup -Name $AzureAdmins -path "OU=Groups,$OrgPath" -Description "Azure Administrators for $Orgname" -GroupScope Global
New-ADGroup -Name $Users -path "OU=Groups,$OrgPath" -Description "Users in the $Orgname OU" -GroupScope Global

#Permission OUs
$acl = Get-ACL "ad:$OrgPath"
$AdminGroup = get-adgroup "$OUAdmins"
$sid = [System.Security.Principal.SecurityIdentifier] $AdminGroup.sid
#Below we create a new access control to allow permission to the OU
$identity = [System.Security.Principal.IdentityReference] $sid
$adRights = [System.DirectoryServices.ActiveDirectoryRights] "GenericAll"
$type = [System.Security.AccessControl.AccessControlType] "Allow"
$inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
$ACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$adRights,$type,$inheritanceType
#Now we add the ACE to the ACL, then set the ACL to save changes
$acl.AddAccessRule($ACE)
Set-Acl -AclObject $acl "ad:$OrgPath"
