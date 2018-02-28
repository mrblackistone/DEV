param(
    [Parameter(Mandatory=$true)]$envDataFilePath,
    [switch]$Deploy
)

$envData = Invoke-Expression (Get-Content -Path $envDataFilePath | Out-String)
$envDataFile = Get-Item $envDataFilePath
$mofLocation = Join-Path -Path "$($envDataFile.DirectoryName)\..\mofs" -ChildPath ($EnvDataFile.BaseName -replace '\.','-')

[DscLocalConfigurationManager()]
configuration 'SetResourceModuleLocation' {
    node $AllNodes.NodeName {
        Settings {
            RefreshMode = 'Push'
            RebootNodeIfNeeded = $false
            ActionAfterReboot = 'StopConfiguration'
            # A configuration Id needs to be specified (bug)
            ConfigurationID = '3a15d863-bd25-432c-9e45-9199afecde91'
        }
        ResourceRepositoryShare FileShare {
            SourcePath = $ConfigurationData.NonNodeData.Data.DSCResourceLocation
        }
    }
}
SetResourceModuleLocation -ConfigurationData $envData -OutputPath $mofLocation

Configuration 'InstallTFS' {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'xSQLServer' -ModuleVersion '5.0.0.0'
    Import-DscResource -ModuleName 'xNetworking' -ModuleVersion '3.2.0.0'

    node $AllNodes.NodeName {
        Group 'Administrators' {
            GroupName        = 'Administrators'
            Credential       = $ConfigurationData.NonNodeData.Accounts.Setup
            MembersToInclude = $ConfigurationData.NonNodeData.Accounts.Admins
        }
        $wmirulenames = 'WMI-RPCSS-In-TCP','WMI-WINMGMT-In-TCP','WMI-WINMGMT-Out-TCP','WMI-ASYNC-In-TCP'
        $wmirulenames | ForEach-Object {
            xFirewall "Enable WMI - $_" {
                Name    = $_
                Enabled = 'True'
            }
        }
        File 'CopyTFSSourceFilesLocally' {
            SourcePath      = $ConfigurationData.NonNodeData.TFS.TFSBitsSource
            DestinationPath = $ConfigurationData.NonNodeData.TFS.TFSBitsDestination
            Type            = 'Directory'
            Recurse         = $true
            Checksum        = 'SHA-256'
            MatchSource     = $true
        }
        $fileloc = Join-Path -Path $ConfigurationData.NonNodeData.TFS.TFSBitsDestination -Child 'TfsServer2018.exe'
        Script 'InstallTFS' {
            GetScript = {
                @{
                    Name    = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1D023F54-0C9D-337E-ACC9-11D03B719EB2}').DisplayName
                    Version = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1D023F54-0C9D-337E-ACC9-11D03B719EB2}').DisplayVersion
                }
            }
            TestScript = {
                Write-Verbose 'Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1D023F54-0C9D-337E-ACC9-11D03B719EB2}"'
                Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1D023F54-0C9D-337E-ACC9-11D03B719EB2}'
                Write-Verbose $?
            }
            SetScript = {
                Write-Verbose "Launching $using:fileloc /quiet ..."
                Start-Process -FilePath $using:fileloc -ArgumentList '/quiet' -Wait
                $global:DSCMachineStatus = 1 
            } 
            DependsOn = '[xSQLServerNetwork]ConfigureSQLPort'
        }
        $tfsserviceaccountname = $ConfigurationData.NonNodeData.Accounts.TFSService.UserName
        $tfsserviceaccountpasswordtxt = $ConfigurationData.NonNodeData.Accounts.TFSService.GetNetworkCredential().Password
        $fqdn = $ConfigurationData.NonNodeData.TFS.TFSPublicSiteName
        $sqlinstance = $Node.NodeName,$ConfigurationData.NonNodeData.SQL.InstanceName -join '\'
        Script 'ConfigureTFS' {
            GetScript = {@{Result = (Test-NetConnection -ComputerName localhost -Port 443).TcpTestSucceeded}}
            TestScript = {(Test-NetConnection -ComputerName localhost -Port 443).TcpTestSucceeded}
            SetScript = {
                Write-Verbose 'Starting Configure TFS Script'
                $verboseArray = @()
                $verboseArray += 'unattend'
                $verboseArray += '/configure'
                $verboseArray += '/type:standard'
                $verboseArray += '/continue'
                $verboseArray += "/inputs:ServiceAccountName=`"{0}`";ServiceAccountPassword=`"{1}`";IsServiceAccountBuiltIn=False;SiteBindings=https:*:443:$($using:fqdn):My:generate;PublicUrl=https://$using:fqdn/tfs;SqlInstance=$($using:sqlinstance)" -f $using:tfsserviceaccountname,'********'
                $verboseArray | ForEach-Object {
                    Write-Verbose "PARAMETER: $_"
                }

                $argsArray = @()
                $argsArray += 'unattend'
                $argsArray += '/configure'
                $argsArray += '/type:standard'
                $argsArray += '/continue'
                $argsArray += "/inputs:ServiceAccountName=`"{0}`";ServiceAccountPassword=`"{1}`";IsServiceAccountBuiltIn=False;SiteBindings=https:*:443:$($using:fqdn):My:generate;PublicUrl=https://$using:fqdn/tfs;SqlInstance=$($using:sqlinstance)" -f $using:tfsserviceaccountname,$using:tfsserviceaccountpasswordtxt
                Start-Process -FilePath 'C:\Program Files\Microsoft Team Foundation Server 2018\Tools\TfsConfig.exe' -ArgumentList $argsArray -Wait 
                #$global:DSCMachineStatus = 1 
            }
            DependsOn = '[Script]InstallTFS'
        }
        File 'CopySQLSourceFilesLocally' {
            SourcePath      = $ConfigurationData.NonNodeData.SQL.SQLBitsSource
            DestinationPath = $ConfigurationData.NonNodeData.SQL.SQLBitsDestination
            Type            = 'Directory'
            Recurse         = $true
            Checksum        = 'SHA-256'
            MatchSource     = $true
        }
        <# Commented out to see if Server 2016 can download and install directly from the internet
        File 'CopyDotNetFilesLocally' {
                SourcePath      = $ConfigurationData.NonNodeData.SQL.DotNetBitsSource
                DestinationPath = $ConfigurationData.NonNodeData.SQL.DotNetBitsDestination
                Type            = 'Directory'
                Recurse         = $true
                Checksum        = 'SHA-256'
                MatchSource     = $true
        }
        #>
        $folders = @($ConfigurationData.NonNodeData.SQL.SQLUserDBDir,
                     $ConfigurationData.NonNodeData.SQL.SQLUserDBLogDir,
                     $ConfigurationData.NonNodeData.SQL.SQLTempDBDir,
                     $ConfigurationData.NonNodeData.SQL.SQLTempDBLogDir,
                     $ConfigurationData.NonNodeData.SQL.SQLBackupDir)
        $sqlResourceDependsOn = @()
        $uniquefolders = $folders | Sort-Object -Unique 
        for($i=0;$i -lt $uniquefolders.count;$i++) {
            $sqlResourceDependsOn += "[File]Folder_$i"
            File "Folder_$i" {
                Type = 'Directory'
                DestinationPath = $uniquefolders[$i]
            }
        }
        WindowsFeature 'DotNet35' {
                Name   = 'Net-Framework-Core'
                #Source = $ConfigurationData.NonNodeData.SQL.DotNetBitsDestination
                #DependsOn = '[File]CopyDotNetFilesLocally'
        }
        $sqlResourceDependsOn += '[WindowsFeature]DotNet35'
        $sqlResourceDependsOn += '[File]CopySQLSourceFilesLocally'
        xSQLServerSetup 'SetupSQL' {
                DependsOn           = $sqlResourceDependsOn
                InstanceName        = $ConfigurationData.NonNodeData.SQL.InstanceName
                SetupCredential     = $ConfigurationData.NonNodeData.Accounts.Setup
                SourcePath          = $ConfigurationData.NonNodeData.SQL.SQLBitsDestination
                Features            = $ConfigurationData.NonNodeData.SQL.SQLFeatures
                SQLSvcAccount       = $ConfigurationData.NonNodeData.Accounts.SQLService
                AgtSvcAccount       = $ConfigurationData.NonNodeData.Accounts.SQLAgent
                SQLSysAdminAccounts = $ConfigurationData.NonNodeData.SQL.SQLSysAdminAccounts
                SQLUserDBDir        = $ConfigurationData.NonNodeData.SQL.SQLUserDBDir
                SQLUserDBLogDir     = $ConfigurationData.NonNodeData.SQL.SQLUserDBLogDir
                SQLTempDBDir        = $ConfigurationData.NonNodeData.SQL.SQLTempDBDir
                SQLTempDBLogDir     = $ConfigurationData.NonNodeData.SQL.SQLTempDBLogDir
                SQLBackupDir        = $ConfigurationData.NonNodeData.SQL.SQLBackupDir
        }
        xSQLServerNetwork 'ConfigureSQLPort' {
            DependsOn            = '[xSQLServerSetup]SetupSQL'
            InstanceName         = $ConfigurationData.NonNodeData.SQL.InstanceName
            TCPPort              = $ConfigurationData.NonNodeData.SQL.SQLEnginePort
            ProtocolName         = 'tcp'
            RestartService       = $true
            IsEnabled            = $true
        }
        Script 'Configure IIS Bindings' {
            DependsOn = '[Script]ConfigureTFS'
            TestScript = {
                Import-Module WebAdministration | Out-Null
                Test-Path 'IIS:\SslBindings\0.0.0.0!443'
            }
            GetScript = {
                Import-Module WebAdministration | Out-Null
                @{Result = Test-Path 'IIS:\SslBindings\0.0.0.0!443'}
            }
            SetScript = {
                Import-Module WebAdministration | Out-Null
                Get-childitem -Path cert:\localmachine\webhosting | New-Item -Path 'IIS:\SslBindings\0.0.0.0!443'
            }
        }
        xFirewall 'SQL Remote Management Firewall Rules' {
            Name          = 'SQL Remote Management Firewall Rule'
            Action        = 'Allow'
            Description   = 'Allows SQL Connections from SQL management servers'
            Direction     = 'Inbound'
            Program       = 'C:\Program Files\Microsoft SQL Server\MSSQL12.TFSDEVOPS\MSSQL\binn\sqlservr.exe'
            Profile       = 'Any'
            RemoteAddress = $ConfigurationData.NonNodeData.SQL.SQLManagementSubnets
        }
        <#
        xFirewall 'Deny RDP Access' {
            Name          = 'Deny RDP Access'
            Action        = 'Block'
            Description   = 'Blocks RDP Access - Use PowerShell for System Management'
            Direction     = 'Inbound'
            Profile       = 'Any'
            LocalPort     = '3389'
            Protocol      = 'TCP'
        }
        #>
    }
}
InstallTFS -ConfigurationData $envData -OutputPath $mofLocation
             
if($Deploy) {
    Write-Host "Start Time: $(Get-Date)"
    Set-DscLocalConfigurationManager -Path $mofLocation -verbose
    Start-DscConfiguration -Path $mofLocation -wait -force -verbose
    Write-Host 'Restarting remote Computer(s)...'
    Restart-Computer -ComputerName ($envData.AllNodes.NodeName | where-object {$_ -ne '*'}) -wait -for PowerShell -Force
    Start-DscConfiguration -ComputerName ($envData.AllNodes.NodeName | where-object {$_ -ne '*'}) -UseExisting -Wait -Verbose -Force
    Write-Host "End Time: $(Get-Date)"
}
