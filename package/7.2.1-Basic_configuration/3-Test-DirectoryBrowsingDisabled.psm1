function Test-DirectoryBrowsingDisabled {
    $isDirectoryBrowsingEnabled = Get-WebConfigurationProperty -Filter system.webserver/directorybrowse -PSPath iis:\ -Name Enabled | Select-Object Value

    if ( $isDirectoryBrowsingEnabled -eq $true ) {
        Write-Warning "Error: IIS had directory browsng enabled!"
        return $false
    }

    Write-Information "IIS had directory browsing disabled"
    return $true
}

function New-DirectoryBrowsingDisabled {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock {Test-DirectoryBrowsingDisabled } `
        -Description "Ensure 'directory browsing' is set to disabled" `
        -Number "${TestNumberPrefix}.3"

    return $newTest
}

Export-ModuleMember -Function *