param(
    [Switch][parameter(HelpMessage="If specified, a log file will be written to the current folder.")]$WriteLogFile,
    [Switch][parameter(HelpMessage="If specified, accounts will only be disabled, none deleted.  Script runs as read-only by default.")]$DisableOnly,
    [Switch][parameter(HelpMessage="If specified without DisableOnly, will allow accounts to be either disabled or deleted depending on age.  Script runs as read-only by default.")]$DisableAndDelete,
    [ValidateRange(60,1000)][parameter(HelpMessage="Minimum days inactive or unused before account is reported for follow-up.")][Int]$daysInactive = 60,
    [ValidateRange(61,1000)][parameter(HelpMessage="Minimum days inactive or unused before account is disabled.")][Int]$daysToDisable = 90,
    [ValidateRange(62,1000)][parameter(HelpMessage="Minimum days inactive or unused before account is deleted.")][Int]$daysToDelete = 150,
    [String]$distinguishedNameExclusionString="*OU=ServiceAccount*",
    [String]$distinguishedNameAllowedString="*OU=Orgs,DC=domain,DC=local"
)

# This script enumerates user accounts in Active Directory with the goal of reporting and then potentially disabling or deleting them based on their age.
# Account age is defined as the number of days since creation (for accounts which never never been logged into) or the number of days since the 
#     LastLogonTimestamp was set (for accounts which have been logged into).
# If no switches are specified, the script runs in Read Only mode and will not disable or delete accounts.
# If the DisableOnly switch is specified, regardless of whether DisableAndDelete is specified, the script will only disable accounts.
# If the DisableAndDelete switch is specified, but the DisableOnly switch is not, then the script will disable or delete accounts based on their age.
# If the WriteLogFile switch is specified, output will be directed to a versioned log file (to prevent overwrites of previous log files) in addition
#     to the screen.  If DisableAndDelete is specified, a log file will be generated anyway.
# The "distinguishedNameExclusionString" parameter:  Objects with a Distinguished Name that contains this wildcard-matching string will not be disabled or deleted.
# The "distinguishedNameAllowedString" parameter:  Objects with a Distinguished Name that contains this wildcard-matching string can be disabled or deleted.
# Because of the nature of how LastLogonTimestamp works, the minimum recommended value is 60 days before considering accounts inactive.
# By default this script list an account as inactive after 60 days, disables after 90 days, and deletes after 150 days of inactivity.

if ($daysToDisable -le $daysInactive) { Throw "Minimum days for account disablement must be greater than minimum days inactive for reporting." }
if ($daysToDelete -le $daysToDisable) { Throw "Minimum days for account deletion action must be greater than minimum days for account disablement." }
if ($DisableOnly) {
    $confirm = Read-Host -Prompt "You are about to disable accounts.  Are you sure you wish to proceed? (Y/N)"
    if ($confirm -ne "Y") { Throw }
} elseif ($DisableAndDelete) {
    $confirm = Read-Host -Prompt "You are about to delete and/or disable accounts.  Are you sure you wish to proceed? (Y/N)"
    if ($confirm -ne "Y") { Throw }
}

Import-Module ActiveDirectory

#Ensure array variables are empty
$NeverLoggedInUsers = $null
$InactiveUsers = $null

#Set up date-related variables
$today = Get-Date
$inactiveDate = $today.AddDays(-($daysInactive))
$disableDate = $today.AddDays(-($daysToDisable))
$deleteDate = $today.AddDays(-($daysToDelete))
$inactiveDateFormatted = $inactiveDate.ToString('M/d/yyyy')

#Initialize additional variables
$output=$null
$accountsDeleted = @()
$accountsDeletedSorted = @()
$accountsDisabled = @()
$accountsDisabledSorted = @()
$output = @()
$output += Write-Output "`r`nSearching Active Directory domain for accounts that may be stale."

#Search for accounts which have never logged in.
[Array]$NeverLoggedInUsers = Get-ADUser -Filter {(LastLogonTimeStamp -notlike "*") -and (whenCreated -lt $inactiveDate) } -Properties LastLogonTimeStamp,DisplayName,whenCreated
if ($NeverLoggedInUsers) {
    $output += Write-Output "`r`n------------------------------------------------------------------------------------------------"
    $output += Write-Output "Searching for accounts that have never logged in and were created more than $daysInactive days ago."
    $output += Write-Output "Sorting from oldest to most recent account creation dates."
    $output += $NeverLoggedInUsers | Sort-Object -Property whenCreated | Format-Table whenCreated,DisplayName,DistinguishedName
    $count = $NeverLoggedInUsers.Count
    $output += Write-Output "There are $count users who have never logged in.`r`n"
}


#Search for accounts which have logged in, but are inactive.
[Array]$InactiveUsers = Get-ADUser -Filter {LastLogonTimeStamp -lt $inactiveDate} -Properties LastLogonTimeStamp,DisplayName,whenCreated
if ($InactiveUsers) {
    $output += Write-Output "`r`n------------------------------------------------------------------------------------------------"
    $output += Write-Output "Searching for accounts that have logged in, but have been inactive for at least $daysInactive days..."
    $output += Write-Output "Sorting from oldest to most recent logons."
    $output += $InactiveUsers | Sort-Object -Property LastLogonTimeStamp | Format-Table whenCreated,@{Label="Last Logon Date"; Expression={([DateTime]::FromFileTime($_.LastLogonTimeStamp))}},DisplayName,DistinguishedName
    $count = $InactiveUsers.Count
    $output += Write-Output "There are $count inactive users.`r`n"
    $output += Write-Output "`r`n------------------------------------------------------------------------------------------------"

}

#Assess and take action against accounts that have never been logged into
if ($NeverLoggedInUsers.count -ne 0) {
    $NeverLoggedInUsers | ForEach-Object {
        if (($_.whenCreated -lt $deleteDate) -and ($_.DistinguishedName -like $distinguishedNameAllowedString) -and ($_.DistinguishedName -notlike $distinguishedNameExclusionString) -and (-not($DisableOnly))) {
            $accountsDeleted += @([PSCustomObject]@{LastName=$_.Surname;FirstName=$_.GivenName;DN=$_.DistinguishedName})
            #if ($DisableAndDelete) { Remove-ADUser -identity $_ -Confirm }
        } elseif (($_.whenCreated -lt $disableDate) -and ($_.DistinguishedName -like $distinguishedNameAllowedString) -and ($_.DistinguishedName -notlike $distinguishedNameExclusionString) ) {
            $accountsDisabled += @([PSCustomObject]@{LastName=$_.Surname;FirstName=$_.GivenName;DN=$_.DistinguishedName})
            #if ($DisableAndDelete) { Disable-ADAccount -Identity $_ }
        } else {
            if ($_.whenCreated -ge $disableDate) { $output += Write-Output "Taking no action against $($_.DisplayName) account because disable or delete minimum days not yet met. ($($_.DistinguishedName))" }
            elseif ($_.DistinguishedName -notlike $distinguishedNameAllowedString) { $output += Write-Output "Taking no action against $($_.DisplayName) account because it does not reside within the Orgs OU.  Please review manually. ($($_.DistinguishedName))" }
            elseif ($_.DistinguishedName -like $distinguishedNameExclusionString) { $output += Write-Output "Taking no action against $($_.DisplayName) account because it resides within a ServiceAccount OU.  Please review manually. ($($_.DistinguishedName))" }
        }
    }
} else { $output += Write-Output "There are no users who have never logged in with account creation times prior to $inactiveDateFormatted" }


#Assess and take action against inactive accounts that have logged in at some point
if ($InactiveUsers.count -ne 0) {
    $inactiveUsers | ForEach-Object {
        $lastLogon = [DateTime]::FromFileTime($_.LastLogonTimeStamp)
        if (($lastLogon -lt $deleteDate) -and ($_.DistinguishedName -like $distinguishedNameAllowedString) -and ($_.DistinguishedName -notlike $distinguishedNameExclusionString) -and (-not($DisableOnly))) {
            $accountsDeleted += @([PSCustomObject]@{LastName=$_.Surname;FirstName=$_.GivenName;DN=$_.DistinguishedName})
            #if ($DisableAndDelete) { Remove-ADUser -identity $_ -Confirm }
        } elseif (($lastLogon -lt $disableDate) -and ($_.DistinguishedName -like $distinguishedNameAllowedString) -and ($_.DistinguishedName -notlike $distinguishedNameExclusionString) ) {
            $accountsDisabled += @([PSCustomObject]@{LastName=$_.Surname;FirstName=$_.GivenName;DN=$_.DistinguishedName})
            #if ($DisableAndDelete) { Disable-ADAccount -Identity $_ }
        } else {
            if ($lastLogon -ge $disableDate) { $output += Write-Output "Taking no action against $($_.DisplayName) account because disable or delete minimum days not yet met. ($($_.DistinguishedName))" }
            elseif ($_.DistinguishedName -notlike $distinguishedNameAllowedString) { $output += Write-Output "Taking no action against $($_.DisplayName) account because it does not reside within the Orgs OU.  Please review manually. ($($_.DistinguishedName))" }
            elseif ($_.DistinguishedName -like $distinguishedNameExclusionString) { $output += Write-Output "Taking no action against $($_.DisplayName) account because it resides within a ServiceAccount OU.  Please review manually. ($($_.DistinguishedName))" }
        }
    }
} else { $output += Write-Output "Of the users that have logged in at some point, none haven't logged in since $inactiveDateFormatted" }

#Sort disabled and deleted lists
$accountsDeletedSorted = $accountsDeleted | Sort-Object -Property LastName
$accountsDisabledSorted = $accountsDisabled | Sort-Object -Property LastName

#Output accounts deleted or disabled, sorted by last name
$output += Write-Output "`r`n------------------------------------------------------------------------------------------------"
$output += "`r`nAccounts Deleted:"
$output += $accountsDeletedSorted | Format-Table
if (-not($accountsDeletedSorted)) {$output += Write-Output "None" }
$output += Write-Output "`r`n------------------------------------------------------------------------------------------------"
$output += "Accounts Disabled:"
$output += $accountsDisabledSorted | Format-Table
if (-not($accountsDisabledSorted)) {$output += Write-Output "None" }


#Output to console and log
$output | Format-List

if ($WriteLogfile -or $DisableAndDelete) {
    $fileVersion = $today.ToString("yyyyddMMhhmmss")
    $output | Out-File .\StaleAccountResults_$($fileVersion).txt
    Write-Host "Results have been stored in the file named .\StaleAccountResults_$($fileVersion).txt"
}

if ((-not($DisableAndDelete)) -and (-not($DisableOnly))) { Write-Host "`r`nScript was run in read-only mode--no accounts were disabled or deleted.  To disable and delete accounts use the -DisableAndDelete switch." -ForegroundColor Yellow -BackgroundColor Black }
