Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1 -Force
Import-Module $PSScriptRoot\..\common\modules\test.prerequisites.psm1 -Force

Write-Information "Testing prerequisites"
Test-Prerequisites
Write-Information "Testing prerequisites end"

$testsNumberPrefix = "7.2.4"
$testsDescription = "$testsNumberPrefix - REQUEST FILTERING AND OTHER RESTRICTION MODULES BENCHMARK CHECKS"

$results = Start-Tests -TestModuleFolder $PSScriptRoot -TestDescription $testsDescription -TestNumberPrefix $testsNumberPrefix
Write-Output $results
