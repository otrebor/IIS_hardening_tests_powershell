Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1
function Get-EnsureStackTracingIsDisabled {
  # Individual Site Config
  return Get-Website | Foreach-Object {
    [PSCustomObject]@{
      "Site"  = $_.Name
      "Trace" = (Get-WebConfiguration -Filter '/system.web/trace' -PSPath "IIS:\sites\$($_.Name)").enabled
    }
  }
}
  
function Test-EnsureStackTracingIsDisabled {
  # Machine Config
  $machineConfig = [System.Configuration.ConfigurationManager]::OpenMachineConfiguration()
  $deployment = $machineConfig.GetSection("system.web/trace")
  
  $results = Get-EnsureStackTracingIsDisabled | ForEach-Object {
    return $_.Trace
  }

  return ($results -notcontains $true) -and (-not $deployment.enabled)
}



function New-EnsureStackTracingIsDisabled {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
    -TestBlock { Test-EnsureStackTracingIsDisabled } `
    -Description "Ensure ASP.NET stack tracing is not enabled" `
    -Number "$TestNumberPrefix.5"

  return $newTest
}

Export-ModuleMember -Function *