function Get-EnsureDinamicIpAddressRestrictionIsEnabled {
  return Get-Website | Foreach-Object {
    $site = $_
    $config = Get-WebConfiguration -Filter '/system.webServer/security/dynamicIpSecurity' -PSPath "IIS:\sites\$($site.Name)"

    [PSCustomObject]@{
      "Site" = $site.Name
      "denyByConcurrentRequests" = $config.denyByConcurrentRequests.enabled
      "denyByRequestRate" = $config.denyByRequestRate.enabled
    }
  }
}
  
  
function Test-EnsureDinamicIpAddressRestrictionIsEnabled {
  If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
    $results = Get-EnsureDinamicIpAddressRestrictionIsEnabled | ForEach-Object {
      return ($_.denyByConcurrentRequests -eq $true)  -and ($_.denyByRequestRate -eq $true)
    }
  
    return $results -notcontains $false
  }
  
  return $true
}
  
function New-EnsureDinamicIpAddressRestrictionIsEnabled {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest -TestBlock { Test-EnsureDinamicIpAddressRestrictionIsEnabled } `
    -Description "Ensure 'Dynamic IP Address Restrictions' is enabled" `
    -Number "${TestNumberPrefix}.11"
  
  return $newTest
}

Export-ModuleMember -Function *