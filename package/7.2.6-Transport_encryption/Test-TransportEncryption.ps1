Import-Module $PSScriptRoot\..\common\modules\test.execution.utilities.psm1 -Force
Import-Module $PSScriptRoot\..\common\modules\test.prerequisites.psm1 -Force

# Script preferences
# $ErrorActionPreference = 'Stop'
# $DebugPreference = 'SilentlyContinue'
# $VerbosePreference = 'SilentlyContinue'
# $InformationPreference = 'Continue'
# $WarningPreference = 'Continue'

Write-Information "Testing prerequisites"
Test-Prerequisites
Write-Information "Testing prerequisites end"

$testsNumberPrefix = "7.2.6"
$testsDescription = "$testsNumberPrefix - Transport Encryption"

$results = Start-Tests -TestModuleFolder $PSScriptRoot -TestDescription $testsDescription -TestNumberPrefix $testsNumberPrefix
Write-Output $results
