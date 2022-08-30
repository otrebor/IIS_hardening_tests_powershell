function Get-EnsureMaxAllowedContentLengthIsConfigured {
    return Get-Website | Foreach-Object {
            $site = $_
            [PSCustomObject]@{
                "Site" = $site.Name
                "maxAllowedContentLength" = (((Get-WebConfiguration -Filter 'system.webServer/security/requestFiltering' -PSPath "IIS:\sites\$($site.Name)").requestLimits).Attributes | Where-Object Name -EQ 'maxAllowedContentLength').Value
            }
        }
}


function Test-EnsureMaxAllowedContentLengthIsConfigured {
    If ((Get-WindowsFeature Web-Filtering).Installed -EQ $true) {
        $results = Get-EnsureMaxAllowedContentLengthIsConfigured | ForEach-Object {
            return $_.maxAllowedContentLength -eq "30000000"
        }

        return $results -notcontains $false
    }

    return $true
}

function New-EnsureMaxAllowedContentLengthIsConfigured {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureMaxAllowedContentLengthIsConfigured } `
        -Description "Ensure 'maxAllowedContentLength' is configured" `
        -Number "${TestNumberPrefix}.1"

    return $newTest
}

Export-ModuleMember -Function *
