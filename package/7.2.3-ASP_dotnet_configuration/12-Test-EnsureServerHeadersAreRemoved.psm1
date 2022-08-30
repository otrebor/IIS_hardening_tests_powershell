Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Test-EnsureServerHeadersAreRemoved {
  $result = Get-WebConfigurationProperty -pspath machine/webroot/apphost -filter 'system.webserver/security/requestfiltering ' -name 'removeServerHeader'
  return $result.Value -eq $true
}

function New-EnsureServerHeadersAreRemoved {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
    -TestBlock { Test-EnsureServerHeadersAreRemoved } `
    -Description "Ensure server headers are removed" `
    -Number "$TestNumberPrefix.12"

  return $newTest
}

Export-ModuleMember -Function *