function Test-WelcomePageIsDisabled {
    return $true
}

function New-WelcomePageIsDisabled {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-WelcomePageIsDisabled } `
        -Description "Ensure that the default 'Welcome' pages are disabled" `
        -Number "${TestNumberPrefix}.8"

    return $newTest
}

Export-ModuleMember -Function *