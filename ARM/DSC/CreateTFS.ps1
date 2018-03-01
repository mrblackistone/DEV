param(
    [Parameter(Mandatory=$true)]$envDataFilePath,
    [switch]$Deploy
)

$envData = @{
    AllNodes = @(
        @{NodeName = '*';PSDSCAllowPlainTextPassword = $true;PSDSCAllowDomainUser = $true},
        @{NodeName = 'tfstest1.demo.local'}
    )
    NonNodeData = @{
        Data = @{
            DSCResourceLocation = '\\mgmt1\dsc\ResourceModules'
        }
        Accounts = @{
            Setup      = Get-Credential -Message 'Setup Account Credential'   -User 'DEMO\SVC-TFS-Setup'
            SQLService = Get-Credential -Message 'SQL Engine Service Account' -User 'DEMO\SVC-TFS-SQL'
            SQLAgent   = Get-Credential -Message 'SQL Agent Service Account'  -User 'DEMO\SVC-TFS-SQLAgent'
            TFSService = Get-Credential -Message 'TFS Service Account '       -User 'DEMO\SVC-TFS-Service'
            Admins = 'DEMO\Core-TFS-Admins'
        }
        SQL = @{
            DotNetBitsSource      = '\\mgmt1\dsc\Sxs'
            DotNetBitsDestination = 'F:\bits\Sxs'
            SQLBitsSource         = '\\mgmt1\dsc\SQL2017'
            SQLBitsDestination    = 'E:\bits\SQL2017'
            InstanceName          = 'TFSDEVOPS'
            SQLFeatures           = 'SQLEngine,FullText'
            SQLSysAdminAccounts   = 'DEMO\Core-TFS-SQLSA'
            InstanceDirectory     = 'E:\Program Files\Microsoft SQL Server'
            InstallShareDirectory = 'E:\Program Files\Microsoft SQL Server'
            InstallShareWoWDir    = 'E:\Program Files (x86)\Microsoft SQL Server'
            SQLUserDBDir          = 'F:\SQLDATA'
            SQLUserDBLogDir       = 'F:\SQLOGS'
            SQLTempDBDir          = 'F:\SQLTEMPDB\tempMDF'
            SQLTempDBLogDir       = 'F:\SQLTEMPDB\tempLDF'
            SQLBackupDir          = 'F:\SQLBACKUP'
            SQLEnginePort         = '54321'
            SQLManagementSubnets  = '25.0.0.0/24'
        }
        TFS = @{
            TFSBitsSource         = '\\mgmt1\dsc\TFS2018'
            TFSBitsDestination    = 'C:\bits\TFS2018'
            TFSPublicSiteName     = 'tfstest1.demo.local'
        }
    }
}

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
            SourcePath = $EnvData.NonNodeData.Data.DSCResourceLocation
        }
    }
}

Configuration 'InstallTFS' {
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Import-DscResource -ModuleName 'xSQLServer' -ModuleVersion '5.0.0.0'
    Import-DscResource -ModuleName 'xNetworking' -ModuleVersion '3.2.0.0'

    node $AllNodes.NodeName {
        Group 'Administrators' {
            GroupName        = 'Administrators'
            Credential       = $EnvData.NonNodeData.Accounts.Setup
            MembersToInclude = $EnvData.NonNodeData.Accounts.Admins
        }
        $wmirulenames = 'WMI-RPCSS-In-TCP','WMI-WINMGMT-In-TCP','WMI-WINMGMT-Out-TCP','WMI-ASYNC-In-TCP'
        $wmirulenames | ForEach-Object {
            xFirewall "Enable WMI - $_" {
                Name    = $_
                Enabled = 'True'
            }
        }
        File 'CopyTFSSourceFilesLocally' {
            SourcePath      = $EnvData.NonNodeData.TFS.TFSBitsSource
            DestinationPath = $EnvData.NonNodeData.TFS.TFSBitsDestination
            Type            = 'Directory'
            Recurse         = $true
            Checksum        = 'SHA-256'
            MatchSource     = $true
        }
        $fileloc = Join-Path -Path $EnvData.NonNodeData.TFS.TFSBitsDestination -Child 'TfsServer2018.exe'
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
        $tfsserviceaccountname = $EnvData.NonNodeData.Accounts.TFSService.UserName
        $tfsserviceaccountpasswordtxt = $EnvData.NonNodeData.Accounts.TFSService.GetNetworkCredential().Password
        $fqdn = $EnvData.NonNodeData.TFS.TFSPublicSiteName
        $sqlinstance = $Node.NodeName,$EnvData.NonNodeData.SQL.InstanceName -join '\'
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
            SourcePath      = $EnvData.NonNodeData.SQL.SQLBitsSource
            DestinationPath = $EnvData.NonNodeData.SQL.SQLBitsDestination
            Type            = 'Directory'
            Recurse         = $true
            Checksum        = 'SHA-256'
            MatchSource     = $true
        }
        <# Commented out to see if Server 2016 can download and install directly from the internet
        File 'CopyDotNetFilesLocally' {
                SourcePath      = $EnvData.NonNodeData.SQL.DotNetBitsSource
                DestinationPath = $EnvData.NonNodeData.SQL.DotNetBitsDestination
                Type            = 'Directory'
                Recurse         = $true
                Checksum        = 'SHA-256'
                MatchSource     = $true
        }
        #>
        $folders = @($EnvData.NonNodeData.SQL.SQLUserDBDir,
                     $EnvData.NonNodeData.SQL.SQLUserDBLogDir,
                     $EnvData.NonNodeData.SQL.SQLTempDBDir,
                     $EnvData.NonNodeData.SQL.SQLTempDBLogDir,
                     $EnvData.NonNodeData.SQL.SQLBackupDir)
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
                #Source = $EnvData.NonNodeData.SQL.DotNetBitsDestination
                #DependsOn = '[File]CopyDotNetFilesLocally'
        }
        $sqlResourceDependsOn += '[WindowsFeature]DotNet35'
        $sqlResourceDependsOn += '[File]CopySQLSourceFilesLocally'
        xSQLServerSetup 'SetupSQL' {
                DependsOn           = $sqlResourceDependsOn
                InstanceName        = $EnvData.NonNodeData.SQL.InstanceName
                SetupCredential     = $EnvData.NonNodeData.Accounts.Setup
                SourcePath          = $EnvData.NonNodeData.SQL.SQLBitsDestination
                Features            = $EnvData.NonNodeData.SQL.SQLFeatures
                SQLSvcAccount       = $EnvData.NonNodeData.Accounts.SQLService
                AgtSvcAccount       = $EnvData.NonNodeData.Accounts.SQLAgent
                SQLSysAdminAccounts = $EnvData.NonNodeData.SQL.SQLSysAdminAccounts
                SQLUserDBDir        = $EnvData.NonNodeData.SQL.SQLUserDBDir
                SQLUserDBLogDir     = $EnvData.NonNodeData.SQL.SQLUserDBLogDir
                SQLTempDBDir        = $EnvData.NonNodeData.SQL.SQLTempDBDir
                SQLTempDBLogDir     = $EnvData.NonNodeData.SQL.SQLTempDBLogDir
                SQLBackupDir        = $EnvData.NonNodeData.SQL.SQLBackupDir
        }
        xSQLServerNetwork 'ConfigureSQLPort' {
            DependsOn            = '[xSQLServerSetup]SetupSQL'
            InstanceName         = $EnvData.NonNodeData.SQL.InstanceName
            TCPPort              = $EnvData.NonNodeData.SQL.SQLEnginePort
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
            RemoteAddress = $EnvData.NonNodeData.SQL.SQLManagementSubnets
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
             