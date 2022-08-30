function Get-EnsureMaxQueryStringIsConfigured {
    return Get-Website | Foreach-Object {
            $site = $_
            [PSCustomObject]@{
                "Site" = $site.Name
                "MaxQueryString" = (((Get-WebConfiguration -Filter 'system.webServer/security/requestFiltering' -PSPath "IIS:\sites\$($site.Name)").requestLimits).Attributes | Where-Object Name -EQ 'maxQueryString').Value
            }
        }
  }
  
  
  function Test-EnsureMaxQueryStringIsConfigured {
    If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
        $results = Get-EnsureMaxQueryStringIsConfigured | ForEach-Object {
            return $_.MaxQueryString -eq "2048"
        }
  
        return $results -notcontains $false
    }
  
    return $true
  }
  
  function New-EnsureMaxQueryStringIsConfigured {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureMaxQueryStringIsConfigured } `
        -Description "Ensure 'MaxQueryString request filter' is configured" `
        -Number "${TestNumberPrefix}.3"
  
    return $newTest
  }

Export-ModuleMember -Function *