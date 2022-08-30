function Get-EnsureHSTSHeaderIsSet {
  return Get-Website | Foreach-Object {
    $site   = $_
    $config = (Get-WebConfiguration -Filter '/system.webServer/httpProtocol' -PSPath "IIS:\sites\$($site.Name)").customHeaders
    $value  = ($config.Attributes | Where-Object Name -EQ 'Strict-Transport-Security').Value
  
    $value | Where-Object { $_ -Match "max-age" }
  }
}

function Test-EnsureHSTSHeaderIsSet {
  $results = Get-EnsureHSTSHeaderIsSet | ForEach-Object {
    if ($null -eq $_.value) {
      return $false
    }
    return ( $_.value -gt 31536000 )
  }

  return $results -notcontains $false
}

function New-EnsureHSTSHeaderIsSet {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureHSTSHeaderIsSet } `
      -Description "Ensure HSTS Header is set" `
      -Number "${TestNumberPrefix}.01"
    
    return $newTest
}

Export-ModuleMember -Function *