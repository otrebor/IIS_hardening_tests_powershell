function Get-EnsureMaxUrlIsConfigured {
  return Get-Website | Foreach-Object {
          $site = $_
          [PSCustomObject]@{
              "Site" = $site.Name
              "maxURL" = (((Get-WebConfiguration -Filter 'system.webServer/security/requestFiltering' -PSPath "IIS:\sites\$($site.Name)").requestLimits).Attributes | Where-Object Name -EQ 'maxURL').Value
          }
      }
}


function Test-EnsureMaxUrlIsConfigured {
  If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
      $results = Get-EnsureMaxUrlIsConfigured | ForEach-Object {
          return $_.maxURL -eq "4096"
      }

      return $results -notcontains $false
  }

  return $true
}

function New-EnsureMaxUrlIsConfigured {
  [CmdletBinding()]
  param (
      [Parameter()]
      [string]
      $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest -TestBlock { Test-EnsureMaxUrlIsConfigured } `
      -Description "Ensure 'maxUrl' is configured" `
      -Number "${TestNumberPrefix}.2"

  return $newTest
}

Export-ModuleMember -Function *