function Get-EnsureUnlistedFileExtensionAreNotAllowed {
    return Get-Website | Foreach-Object {
        $site = $_
        [PSCustomObject]@{
            "Site" = $site.Name
            "allowUnlisted" = (((Get-WebConfiguration -Filter 'system.webServer/security/requestFiltering' -PSPath "IIS:\sites\$($site.Name)").fileExtensions).Attributes | Where-Object Name -EQ 'allowUnlisted').Value
        }
    }
  }
  
  
  function Test-EnsureUnlistedFileExtensionAreNotAllowed {
    If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
        $results = Get-EnsureUnlistedFileExtensionAreNotAllowed | ForEach-Object {
            return $_.allowUnlisted -eq $false
        }
  
        return $results -notcontains $false
    }
  
    return $true
  }
  
  function New-EnsureUnlistedFileExtensionAreNotAllowed {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureUnlistedFileExtensionAreNotAllowed } `
        -Description "Ensure Unlisted File Extensions are not allowed" `
        -Number "${TestNumberPrefix}.7"
  
    return $newTest
  }

Export-ModuleMember -Function *