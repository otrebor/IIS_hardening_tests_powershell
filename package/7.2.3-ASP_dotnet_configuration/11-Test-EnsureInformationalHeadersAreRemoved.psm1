Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Get-EnsureInformationalHeadersAreRemoved {
  return Get-Website | Foreach-Object {
    $site = $_
    $config = Get-WebConfiguration -Filter '/system.webServer/httpProtocol/customHeaders' -PSPath "IIS:\sites\$($site.Name)"
  
    $customHeaders = $config.GetCollection()
  
    If ($customHeaders) {
        $customHeaders | ForEach-Object {
                $poweredBy = ($_.Attributes | Where-Object Name -EQ name).Value -match 'x-powered-by'
                $aspnetVersion = ($_.Attributes | Where-Object Name -EQ name).Value -match 'x-aspnet-version'
                $aspnetmvcVersion = ($_.Attributes | Where-Object Name -EQ name).Value -match 'x-aspnetmvc-version'
            [PSCustomObject]@{
                "Site" = $site.Name
                "X-Powered-By" = $poweredBy
                "X-AspNet-Version" = $aspnetVersion
                "X-AspNetMvc-Version" = $aspnetmvcVersion
                "Success" = -not ($poweredBy -or $aspnetVersion -or $aspnetmvcVersion)
            }
        }
    }
  }
}

function Test-EnsureInformationalHeadersAreRemoved {
  $results = Get-EnsureInformationalHeadersAreRemoved | ForEach-Object {
    return $_.Success
  }
  return $results -notcontains $false
}

function New-EnsureInformationalHeadersAreRemoved {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
    -TestBlock { Test-EnsureInformationalHeadersAreRemoved } `
    -Description "Ensure informational headers are removed" `
    -Number "$TestNumberPrefix.11"

  return $newTest
}

Export-ModuleMember -Function *