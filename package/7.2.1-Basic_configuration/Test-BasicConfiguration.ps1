Import-Module $PSScriptRoot\..\common\modules\scripts.utilities.psm1 -Force 
Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1 -Force
Import-Module $PSScriptRoot\..\common\modules\test.prerequisites.psm1 -Force

Get-ChildItem $PSScriptRoot -Filter *.psm1 | 
Foreach-Object {
    $module = $_.FullName
    Write-Information "Importing $module"
    Import-Module -Name $module -Force
}

Write-Information "Testing prerequisites"
Test-Prerequisites
Write-Information "Testing prerequisites end"

$testsNumberPrefix = "7.2.1"
$testsDescription = "$testsNumberPrefix - Testing Basic Configuration"

$results = Start-Tests -TestModuleFolder $PSScriptRoot -TestDescription $testsDescription -TestNumberPrefix $testsNumberPrefix
Write-Output $results
