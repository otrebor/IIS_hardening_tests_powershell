Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Get-EnsureDotNetTrustLevelIsConfigured {
  return Get-Website | Foreach-Object {
    $site = $_
    $applicationPool = $_.applicationPool
    If ($applicationPool) {
        $pools = Get-WebApplication -Site $_.Name
  
        $pools | ForEach-Object {
            $appPool    = ($_.Attributes | Where-Object Name -EQ 'applicationPool').Value
            $properties = Get-ItemProperty -Path "IIS:\AppPools\$appPool" | Select-Object *
            $version    = $properties.managedRuntimeVersion
  
            $level = (Get-WebConfiguration -Filter '/system.web/trust' -PSPath "IIS:\sites\$($site.Name)").level
  
            [PSCustomObject]@{
                "Site"    = $site.Name
                "AppPool" = $appPool
                "Version" = $version
                "Level"   = $Level
            }
        }
    }
  }
}
  
  
function Test-EnsureDotNetTrustLevelIsConfigured {
  $results = Get-EnsureDotNetTrustLevelIsConfigured | ForEach-Object {
    return $_.Level -eq "Medium"
  }
  return $results -notcontains $false
}

function New-EnsureDotNetTrustLevelIsConfigured {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $TestNumberPrefix
  )
  $newTest = New-IISHardeningTest `
    -TestBlock { Test-EnsureDotNetTrustLevelIsConfigured } `
    -Description "Ensure global .NET trust level is configured" `
    -Number "$TestNumberPrefix.10"

  return $newTest
}

Export-ModuleMember -Function *