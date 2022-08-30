Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Get-DebugTurnedOff {
  return Get-Website | Foreach-Object {
    [PSCustomObject]@{
      "Site"  = $_.Name
      "Debug" = (Get-WebConfiguration -Filter '/system.web/compilation' -PSPath "IIS:\sites\$($_.Name)").Debug
    }
  }
}

function Test-DebugTurnedOff {
  $results = Get-DebugTurnedOff | ForEach-Object {
    return $_.Debug
  }
  return $results -notcontains $false
}

function New-DebugTurnedOff {
  [CmdletBinding()]
  param (
      [Parameter()]
      [string]
      $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
           -TestBlock { Test-DebugTurnedOff } `
           -Description "Ensure debug is turned off" `
           -Number "$TestNumberPrefix.2"

  return $newTest
}

Export-ModuleMember -Function *