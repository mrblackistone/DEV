param(
    [Parameter(Mandatory=$true)]$username,
    [Parameter(Mandatory=$true)]$password,
    [Parameter(Mandatory=$true,helpmessage="The name of the other file to run which must be in the working folder along with its command line parameters.")][string]$filenameWithParams
)

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path .\output.txt #-append


[securestring]$securePassword = $Password | ConvertTo-SecureString -asplaintext -force
$PSCredential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

Write-host "Kicking off other script"
start-process powershell.exe -NoNewWindow -ArgumentList ("-file $filenameWithParams") -Wait #-Credential $PSCredential

Stop-Transcript
get-content .\outputMain.txt
get-content .\output.txt