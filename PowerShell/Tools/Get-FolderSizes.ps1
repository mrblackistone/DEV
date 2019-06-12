function Get-DirSize {
    <#
    .Synopsis
      Gets a list of directories and sizes.
    .Description
      This function recursively walks the directory tree and returns the size of 
      each directory found.
    .Parameter path
      The path of the root folder to start scanning.
    .Example
      (Get-DirSize $env:userprofile | sort Size)[-2]
      Get the largest folder under the user profile. 
    .Example
      Get-DirSize -path “c:data” | Sort-Object -Property size -Descending
      Displays folders and sub folders from c:data in descending size order
    .Outputs
      [PSObject]
    .Notes
     NAME:  Get-DirSize
     AUTHOR: ToJo2000 
     LASTEDIT: 8/12/2009
     KEYWORDS: 2009 Summer Scripting Games, Beginner Event 8, Get-ChildItem, Files and Folders
    .Link
     Http://www.ScriptingGuys.com
    #Requires -Version 2.0
    #>
      param([Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$path)
      BEGIN {}
     
      PROCESS{
        $size = 0
        $folders = @()
      
        foreach ($file in (Get-ChildItem $path -Force -ea SilentlyContinue)) {
          if ($file.PSIsContainer) {
            $subfolders = @(Get-DirSize $file.FullName)
            $size += $subfolders[-1].Size
            $folders += $subfolders
          } else {
            $size += $file.Length
          }
        }
      
        $object = New-Object -TypeName PSObject
        $object | Add-Member -MemberType NoteProperty -Name Folder `
                             -Value (Get-Item $path).FullName
        $object | Add-Member -MemberType NoteProperty -Name Size -Value $size
        $folders += $object
        Write-Output $folders
      }
      
      END {}
    } # end function Get-DirSize