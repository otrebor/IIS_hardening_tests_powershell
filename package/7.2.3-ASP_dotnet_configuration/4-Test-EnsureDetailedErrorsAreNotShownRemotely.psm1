Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Get-EnsureDetailedErrorsAreNotShownRemotely {
  return Get-Website | Foreach-Object {
    $errorMode = (Get-WebConfiguration -Filter '/system.webServer/httpErrors' -PSPath "IIS:\sites\$($_.Name)").errorMode
    
    [PSCustomObject]@{
      "Site"      = $_.Name
      "ErrorMode" = $errorMode
      "Errors"    = $(If (($errorMode -NE 'Custom') -And ($errorMode -NE 'DetailedLocalOnly') ) { $False } Else { $True })
    }
  }
}
  
  
function Test-EnsureDetailedErrorsAreNotShownRemotely {
  $results = Get-EnsureDetailedErrorsAreNotShownRemotely | ForEach-Object {
    return $_.Errors
  }
  return $results -notcontains $false
}

function New-EnsureDetailedErrorsAreNotShownRemotely {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
    -TestBlock { Test-EnsureDetailedErrorsAreNotShownRemotely } `
    -Description "Ensure IIS HTTP detailed errors are hidden from displaying remotely" `
    -Number "$TestNumberPrefix.4"

  return $newTest
}

Export-ModuleMember -Function *