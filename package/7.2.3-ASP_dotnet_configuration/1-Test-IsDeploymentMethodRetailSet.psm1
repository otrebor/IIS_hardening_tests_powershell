Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1

function Test-IsDeploymentMethodRetailSet {
    $machineConfig = [System.Configuration.ConfigurationManager]::OpenMachineConfiguration()
    $deployment = $machineConfig.GetSection("system.web/deployment")
    return $deployment.Retail -eq $true
}

function New-IsDeploymentMethodRetailSet {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-IsDeploymentMethodRetailSet } `
        -Description "Ensure 'deployment method retail' is set" `
        -Number "${TestNumberPrefix}.1"

    return $newTest
}


Export-ModuleMember -Function *