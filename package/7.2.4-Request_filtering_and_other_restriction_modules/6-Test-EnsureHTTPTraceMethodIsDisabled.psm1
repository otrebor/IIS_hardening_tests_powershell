function Get-EnsureHTTPTraceMethodIsDisabled {
    return Get-Website | Foreach-Object {
        $site = $_
        [PSCustomObject]@{
            "Site" = $site.Name
            "allowDoubleEscaping" = (Get-WebConfiguration -Filter 'system.webServer/security/requestFiltering' -PSPath "IIS:\sites\$($site.Name)").allowDoubleEscaping
        }
    }
  }
  
  
  function Test-EnsureHTTPTraceMethodIsDisabled {
    If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
        $results = Get-EnsureHTTPTraceMethodIsDisabled | ForEach-Object {
            return $_.allowDoubleEscaping
        }
  
        return $results -notcontains $false
    }
  
    return $true
  }
  
  function New-EnsureHTTPTraceMethodIsDisabled {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureHTTPTraceMethodIsDisabled } `
        -Description "Ensure 'HTTP Trace Method' is disabled" `
        -Number "${TestNumberPrefix}.6"
  
    return $newTest
  }

Export-ModuleMember -Function *