Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Get-EnsureCookiesAreSetWithHttpOnlyAttribute {
  # Individual Site Config
  return Get-Website | Foreach-Object {
    [PSCustomObject]@{
      "Site"  = $_.Name
      "httpCookies" = (Get-WebConfiguration -Filter '/system.web/httpCookies' -PSPath "IIS:\sites\$($_.Name)").httpOnlyCookies
    }
  }
}
  
  
function Test-EnsureCookiesAreSetWithHttpOnlyAttribute {
  $results = Get-EnsureCookiesAreSetWithHttpOnlyAttribute | ForEach-Object {
    return $_.httpCookies
  }

  return $results -notcontains $false
}

function New-EnsureCookiesAreSetWithHttpOnlyAttribute {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
    -TestBlock { Test-EnsureCookiesAreSetWithHttpOnlyAttribute } `
    -Description "Ensure 'cookies' are set with HttpOnly attribute" `
    -Number "$TestNumberPrefix.7"

  return $newTest
}

Export-ModuleMember -Function *