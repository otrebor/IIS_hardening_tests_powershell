Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Get-EnsureMachineKeyValidationMethodNet_3_5 {
  # Individual Site Config
  return Get-Website | Foreach-Object {
    $site = $_
    $applicationPool = $_.applicationPool
    If ($applicationPool) {
        $pools = Get-WebApplication -Site $_.Name
  
        $pools | ForEach-Object {
            $appPool    = ($_.Attributes | Where-Object Name -EQ 'applicationPool').Value
            $properties = Get-ItemProperty -Path "IIS:\AppPools\$appPool" | Select-Object *
            $version    = $properties.managedRuntimeVersion
  
            If ($version -Like "v2.*") {
                $validation = (Get-WebConfiguration -Filter '/system.web/machineKey' -PSPath "IIS:\sites\$($site.Name)").Validation
  
                [PSCustomObject]@{
                    "Site"       = $site.Name
                    "AppPool"    = $appPool
                    "Version"    = $properties.managedRuntimeVersion
                    "Validation" = $validation
                }
            }
        }
    }
  }
}
  
  
function Test-EnsureMachineKeyValidationMethodNet_3_5 {
  $results = Get-EnsureMachineKeyValidationMethodNet_3_5 | ForEach-Object {
    return $_.Validation -eq "SHA1"
  }

  return $results -notcontains $false
}

function New-EnsureMachineKeyValidationMethodNet_3_5 {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
    -TestBlock { Test-EnsureMachineKeyValidationMethodNet_3_5 } `
    -Description "Ensure 'MachineKey validation method - .Net 3.5' is configured as SHA1" `
    -Number "$TestNumberPrefix.8"

  return $newTest
}

Export-ModuleMember -Function *