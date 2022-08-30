function Get-IISSitesLogfiles {
    $sites = Get-ChildItem -Path 'IIS:\Sites' | ForEach-Object {
        $sitePath = 'IIS:\Sites\' + $_.Name 
        (Get-ItemProperty -Path $sitePath -Name logfile)
    }
    return $sites

    # Get-Website | Foreach-Object {
    #     $site = $_
      
    #     [PSCustomObject]@{
    #       "Site" = $site.Name
    #       "Location" = $Site.logFile.Directory
    #     }
    #   }
}


function Test-DefaultIISLogNotInDefaultLocation {
    $defaultLogFolder = "$Env:SystemDrive\inetpub\logs\LogFiles"

    $loggingFiles = Get-IISSitesLogfiles

    $results = $loggingFiles | ForEach-Object {
        $logDir = $_.directory
        if ("$defaultLogFolder" -eq "$logDir") {
            Write-Warning "Ensure Default IIS weblog location is moved"
            return $false
        }
        return $true
    }
    
    return $results -notcontains $false
}

function New-DefaultIISLogNotInDefaultLocation {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-DefaultIISLogNotInDefaultLocation } `
      -Description "Ensure 'notListedIsapisAllowed' is set to false" `
      -Number "${TestNumberPrefix}.1"
    
    return $newTest
  }

Export-ModuleMember -Function *