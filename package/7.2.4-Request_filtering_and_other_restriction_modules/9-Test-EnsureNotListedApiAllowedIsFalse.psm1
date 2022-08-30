function Get-EnsureNotListedApiAllowedIsFalse {
    return Get-Website | Foreach-Object {
      $site = $_
    
      [PSCustomObject]@{
        "Site" = $site.Name
        "notListedIsapisAllowed" = (Get-WebConfiguration -Filter 'system.webServer/security/isapiCgiRestriction' -PSPath "IIS:\sites\$($site.Name)").notListedIsapisAllowed
      }
    }
  }
  
  
  function Test-EnsureNotListedApiAllowedIsFalse {
    If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
        $results = Get-EnsureNotListedApiAllowedIsFalse | ForEach-Object {
            return $_.notListedIsapisAllowed -eq $false
        }
  
        return $results -notcontains $false
    }
  
    return $true
  }
  
  function New-EnsureNotListedApiAllowedIsFalse {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureNotListedApiAllowedIsFalse } `
        -Description "Ensure 'notListedIsapisAllowed' is set to false" `
        -Number "${TestNumberPrefix}.9"
  
    return $newTest
  }

Export-ModuleMember -Function *