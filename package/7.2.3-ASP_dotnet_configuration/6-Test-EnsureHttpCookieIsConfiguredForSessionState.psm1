Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Get-EnsureHttpCookieIsConfiguredForSessionState {
  # Individual Site Config
  return Get-Website | Foreach-Object {
    $sessionState = (Get-WebConfiguration -Filter '/system.web/sessionState' -PSPath "IIS:\sites\$($_.Name)").cookieless
  
    [PSCustomObject]@{
      "Site"  = $_.Name
      "SessionState" = $sessionState
      "CookieLess" = $(If(($sessionState -NE "UseCookies") -And ($sessionState -NE "False")) { $false } Else { $true })
    }
  }
}
  
  
function Test-EnsureHttpCookieIsConfiguredForSessionState {
  $results = Get-EnsureHttpCookieIsConfiguredForSessionState | ForEach-Object {
    return $_.Trace
  }

  return $results -notcontains $false
}

function New-EnsureHttpCookieIsConfiguredForSessionState {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
    -TestBlock { Test-EnsureHttpCookieIsConfiguredForSessionState } `
    -Description "Ensure 'httpcookie' mode is configured for session state" `
    -Number "$TestNumberPrefix.6"

  return $newTest
}

Export-ModuleMember -Function *