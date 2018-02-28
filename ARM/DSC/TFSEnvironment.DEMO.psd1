@{
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
            SQLManagementSubnets  = '10.0.0.0/24'
        }
        TFS = @{
            TFSBitsSource         = '\\mgmt1\dsc\TFS2018'
            TFSBitsDestination    = 'C:\bits\TFS2018'
            TFSPublicSiteName     = 'tfstest1.demo.local'
        }
    }
}