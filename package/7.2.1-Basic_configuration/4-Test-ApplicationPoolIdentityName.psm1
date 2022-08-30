
Import-Module $PSScriptRoot\..\common\modules\iis.applicationPoolIdentities.utilities.psm1 -Force

function Test-ApplicationPoolIdentityName {
    $applicationPoolsItems =  Get-ApplicationPoolIdentity

    $applicationPoolsItems | ForEach-Object {
        
        if ($_.ServiceAccount -like "*ApplicationPoolIdentity*") {
            Write-Warning "ApplicationPoolIdentity is running a applicationPool"
            return $false;
        }
    }
    Write-Information "All good folks!"
    return $true
}

function New-ApplicationPoolIdentityName {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock {Test-ApplicationPoolIdentityName } `
        -Description "Ensure 'application pool identity' is configured for all application pools" `
        -Number "${TestNumberPrefix}.4"

    return $newTest
}

Export-ModuleMember -Function *