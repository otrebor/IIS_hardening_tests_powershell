function Get-EnsureDoubleEncodedRequestsRejected {
    return Get-Website | Foreach-Object {
        $site = $_
        [PSCustomObject]@{
            "Site" = $site.Name
            "allowDoubleEscaping" = (Get-WebConfiguration -Filter 'system.webServer/security/requestFiltering' -PSPath "IIS:\sites\$($site.Name)").allowDoubleEscaping
        }
    }
  }
  
  
  function Test-EnsureDoubleEncodedRequestsRejected {
    If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
        $results = Get-EnsureDoubleEncodedRequestsRejected | ForEach-Object {
            return $_.allowDoubleEscaping
        }
  
        return $results -notcontains $false
    }
  
    return $true
  }
  
  function New-EnsureDoubleEncodedRequestsRejected {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureDoubleEncodedRequestsRejected } `
        -Description "Ensure Double-Encoded requests will be rejected" `
        -Number "${TestNumberPrefix}.5"
  
    return $newTest
  }

Export-ModuleMember -Function *