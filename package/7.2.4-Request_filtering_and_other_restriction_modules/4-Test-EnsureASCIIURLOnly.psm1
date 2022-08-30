function Get-EnsureASCIIURLOnly {
    return Get-Website | Foreach-Object {
        $site = $_
        [PSCustomObject]@{
            "Site" = $site.Name
            "allowHighBitCharacters" = (Get-WebConfiguration -Filter 'system.webServer/security/requestFiltering' -PSPath "IIS:\sites\$($site.Name)").allowHighBitCharacters
        }
    }
  }
  
  
  function Test-EnsureASCIIURLOnly {
    If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
        $results = Get-EnsureASCIIURLOnly | ForEach-Object {
            return $_.allowHighBitCharacters
        }
  
        return $results -notcontains $false
    }
  
    return $true
  }
  
  function New-EnsureASCIIURLOnly {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureASCIIURLOnly } `
        -Description "Ensure non-ASCII characters in URLs are not allowed" `
        -Number "${TestNumberPrefix}.4"
  
    return $newTest
  }

Export-ModuleMember -Function *