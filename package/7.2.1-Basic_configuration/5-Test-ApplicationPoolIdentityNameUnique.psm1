Import-Module $PSScriptRoot\..\common\modules\iis.applicationPoolIdentities.utilities.psm1 -Force

function Test-ApplicationPoolIdentityNameUnique {
    $appPoolIdentity = Get-ApplicationPoolIdentity

    $appPoolNameSet = $appPoolIdentity | ForEach-Object { $_.Name }
    $appPoolNameSetGrouped = $appPoolNameSet | Group-Object -NoElement

    if("${appPoolNameSet.Length}" -ne "${appPoolNameSetGrouped.Lenght}") {
        return $false
    } 
    return $true
}

function New-ApplicationPoolIdentityNameUnique {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock {Test-ApplicationPoolIdentityNameUnique } `
        -Description "Ensure 'unique application pools' is set for sites" `
        -Number "${TestNumberPrefix}.5"

    return $newTest
}

Export-ModuleMember -Function *