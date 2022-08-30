[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Hostname = 'dotnet-host',
    [Parameter()]
    [string]
    $ReportFileNamePrefix = 'IIS_Hardening_Verification'
)

Import-Module $PSScriptRoot\common\modules\test.execution.utilities.psm1 -Force
Import-Module $PSScriptRoot\common\modules\test.prerequisites.psm1 -Force

# Script preferences
# $ErrorActionPreference = 'Stop'
# $DebugPreference = 'SilentlyContinue'
# $VerbosePreference = 'SilentlyContinue'
# $InformationPreference = 'Continue'
# $WarningPreference = 'Continue'

function Get-TestDescriptionFromFolder {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DirectoryName
    )
    $directoryName = $DirectoryName
    $split = $directoryName -Split '(-)'

    $testsNumberPrefix = $split[0]
    $testsDescriptionAppendix = $directoryName.Substring($testsNumberPrefix.Length + 1).Replace('_', ' ')
    return "$testsNumberPrefix - $testsDescriptionAppendix"
}

function Get-TestNumberFromFolder {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DirectoryName
    )
    $directoryName = $DirectoryName
    $split = $directoryName -Split '(-)'

    return $split[0]
}

Write-Information "Testing prerequisites"
Test-Prerequisites
Write-Information "Testing prerequisites end"

$testDirectories = Get-ChildItem $PSScriptRoot -Directory | where-object {$_.Name -like "[0-9.]*-*"}

$testResults = @()
Write-Host $PSScriptRoot
$testDirectories | ForEach-Object {
    $directory = $_
    $testsNumberPrefix = Get-TestNumberFromFolder -DirectoryName $directory.Name
    $testsDescription = Get-TestDescriptionFromFolder -DirectoryName $directory.Name
    $testResults += Start-Tests -TestModuleFolder $directory.FullName -TestDescription $testsDescription -TestNumberPrefix $testsNumberPrefix -Hostname $Hostname
}

$testResults | Format-Table
$csvPath = ".\$ReportFileNamePrefix-$Hostname.csv"
$testResults | Export-CSV  $csvPath -NoTypeInformation
Write-Output $csvPath