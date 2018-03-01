configuration CreateADPDC 
{ 
    Node localhost
    {
        WindowsFeature 'RSATTools'
        {
            Ensure = 'Present'
            Name = 'RSAT-AD-Tools'
            IncludeAllSubFeature = $true
        }
   }
}