function Get-EnsureHandlerHasNoWriteScriptExecute {
    return Get-Website | Foreach-Object {
        $site = $_
    
        [PSCustomObject]@{
          "Site" = $site.Name
          "accessPolicy" = (Get-WebConfiguration -Filter 'system.webServer/handlers' -PSPath "IIS:\sites\$($site.Name)").accessPolicy
        }
    }
  }
  
  
  function Test-EnsureHandlerHasNoWriteScriptExecute {
    If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
        $results = Get-EnsureHandlerHasNoWriteScriptExecute | ForEach-Object {
            return ($_.accessPolicy -like "*Execute,Script*") -or ($_.accessPolicy -like "*Write*")
        }
  
        return $results -notcontains $false
    }
  
    return $true
  }
  
  function New-EnsureHandlerHasNoWriteScriptExecute {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureHandlerHasNoWriteScriptExecute } `
        -Description "Ensure Handler is not granted Write and Script/Execute" `
        -Number "${TestNumberPrefix}.8"
  
    return $newTest
  }

Export-ModuleMember -Function *