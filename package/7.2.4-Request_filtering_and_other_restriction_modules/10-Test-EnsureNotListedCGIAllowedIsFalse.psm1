function Get-EnsureNotListedCGIAllowedIsFalse {
  return Get-Website | Foreach-Object {
    $site = $_
    
    [PSCustomObject]@{
      "Site"                   = $site.Name
      "notListedIsapisAllowed" = (Get-WebConfiguration -Filter 'system.webServer/security/isapiCgiRestriction' -PSPath "IIS:\sites\$($site.Name)").notListedCgisAllowed
    }
  }
}
  
  
function Test-EnsureNotListedCGIAllowedIsFalse {
  If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
    $results = Get-EnsureNotListedCGIAllowedIsFalse | ForEach-Object {
      return $_.notListedIsapisAllowed -eq $false
    }
  
    return $results -notcontains $false
  }
  
  return $true
}
  
function New-EnsureNotListedCGIAllowedIsFalse {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest -TestBlock { Test-EnsureNotListedCGIAllowedIsFalse } `
    -Description "Ensure 'notListedIsapisCGI' is set to false" `
    -Number "${TestNumberPrefix}.10"
  
  return $newTest
}

Export-ModuleMember -Function *