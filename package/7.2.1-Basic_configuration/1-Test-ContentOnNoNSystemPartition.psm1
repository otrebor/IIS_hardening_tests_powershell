function Test-WebSitesAreInFolder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $PathPrefix
    )
    $results = Get-Website | ForEach-Object {
        $websitePhysicalPath = $_.PhysicalPath
        $websiteName = $_.Name
        if(-not ($websitePhysicalPath -like "$PathPrefix*")) {
            Write-Warning "$websiteName is not installed in $PathPrefix ($websitePhysicalPath)"
            return $false
        }
        return $true
    }
    Write-Information "Website is in installed in $PathPrefix"
    return $results -notcontains $false
}
function Test-ContentOnNoNSystemPartition {
    # Name ID State PhysicalPath Bindings 
    $results = Get-Website | ForEach-Object {
        if($_.PhysicalPath -like "${env:SystemDrive}*") {
            Write-Warning "${_.Name} is installed in SystemDrive ${env:SystemDrive} (${_.PhysicalPath})"
            return $false
        }
        return $true
    }
    Write-Information "Website is in installed in in SystemDrive ${env:SystemDrive}"
    return $results -notcontains $false
}

function New-ContentOnNoNSystemPartition {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock {Test-ContentOnNoNSystemPartition } `
        -Description "Ensure web content is on non-system partition" `
        -Number "${TestNumberPrefix}.1"

    return $newTest
}

Export-ModuleMember -Function *
# Ensure web content is on non-system partition
# Test-WebSitesNotOnSystemDrive
# Test-WebSitesAreInFolder -PathPrefix 'D:\Web\'