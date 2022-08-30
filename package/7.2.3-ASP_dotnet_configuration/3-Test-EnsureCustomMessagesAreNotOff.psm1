Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Get-EnsureCustomMessagesAreNotOff {
    Get-Website | Foreach-Object {
        $mode = (Get-WebConfiguration -Filter '/system.web/customErrors' -PSPath "IIS:\sites\$($_.Name)").Mode
      
        [PSCustomObject]@{
          "Site"  = $_.Name
          "Mode"  = $mode
          "CustomErrors" = $(If($mode -EQ 'off'){$false}Else{$true})
        }
      }
}
  
function Test-EnsureCustomMessagesAreNotOff {
    $results = Get-EnsureCustomMessagesAreNotOff | ForEach-Object {
        return $_.Debug
    }
    return $results -notcontains $false
}

function New-EnsureCustomMessagesAreNotOff {
  [CmdletBinding()]
  param (
      [Parameter()]
      [string]
      $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
           -TestBlock { Test-EnsureCustomMessagesAreNotOff } `
           -Description "Ensure custom error messages are not off" `
           -Number "$TestNumberPrefix.3"

  return $newTest
}

Export-ModuleMember -Function *