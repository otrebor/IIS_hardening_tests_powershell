function Test-WebDavPublishingFeatureIsDisabled {
    $items = Get-WindowsFeature Web-DAV-Publishing
    
    $installed = $false
    $items | ForEach-Object {    
        $obj = $_

        if ($obj.InstallState -like "Installed"){
            Write-Output "bad boy"
            $installed = $true
            break
        }
    }

    if ( $true -eq $installed ) {
        $features = Get-WindowsOptionalFeature -Online -FeatureName "Web-DAV-Publishing"
        $features | ForEach-Object { 
            $obj = $_
            if ($obj.State -like "Enabled"){
                Write-Warning "Web-DAV-Publishing enabled"
                return $false
            }
        }
    }

    Write-Information "Web-DAV-Publishing is disabled"
    return $true
}

function New-WebDavPublishingFeatureIsDisabled {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-WebDavPublishingFeatureIsDisabled } `
        -Description "Ensure WebDav feature is disabled" `
        -Number "${TestNumberPrefix}.7"

    return $newTest
}

Export-ModuleMember -Function *
