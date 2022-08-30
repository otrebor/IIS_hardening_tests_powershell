Import-Module $PSScriptRoot\scripts.utilities.psm1 -Force 
Import-Module $PSScriptRoot\test.prerequisites.psm1 -Force

function Invoke-Test {
    param (
        [Parameter(Mandatory)]
        [Scriptblock] $Test,
        [Parameter(Mandatory)]
        [string] $Name,
        [Parameter(Mandatory)]
        [string] $Number
    )
    Write-Information "Invoke-Test $testBlock -Name $testName -Number $testNumber"
    $success = & $Test
    Write-Information "Executed test: $Number [$Name]  -> result: $success"
    return $success
}

function Invoke-Tests {
    param(
        [parameter(Mandatory, ValueFromPipeline)]
        [object[]]$TestsArray,
        [parameter()]
        [string]$TestsDescription = 'Test',
        [parameter()]
        [string]$Hostname = 'localhost'
    )
    Process {
        Write-Information "Start execution $TestsDescription"
        
        $results = $TestsArray | ForEach-Object { 
            $testBlock = $_.TestBlock
            $testName = $_.Description
            $testNumber = $_.Number
            $isTestSucceded = $null
            
            try {
                $isTestSucceded = Invoke-Test $testBlock -Name $testName -Number $testNumber
            } catch {
                Write-Warning "Test $testNumber raised an exception"
            }

            $testResult = "Error"
            if ($isTestSucceded -eq $true){
                $testResult = "Pass"
            } 
            if ($isTestSucceded -eq $false) {
                $testResult = "Fail"
            }
            return [PSCustomObject]@{
                Hostname        = $Hostname
                TestNumber      = $testNumber
                Result        = $testResult
                TestDescription = $testName
            }
        }

        Write-Information "End execution $testDescription"
        return $results
    }
}

function New-IISHardeningTest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Scriptblock] $TestBlock,
        [Parameter(Mandatory)]
        [string] $Description,
        [Parameter(Mandatory)]
        [string] $Number
    )
    return [PSCustomObject]@{
        "TestBlock"   = $TestBlock
        "Description" = $Description
        "Number"      = $Number
    }
}

function Start-Tests {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $TestModuleFolder,
        [Parameter(Mandatory)]
        [string]
        $TestDescription,
        [Parameter(Mandatory)]
        [string]
        $TestNumberPrefix,
        [Parameter()]
        [string]
        $Hostname = 'localhost'
    )
    
    Write-Information "Reading tests from folder $TestModuleFolder"
    $tests = @()
    if ((Get-ChildItem $TestModuleFolder -Filter *.psm1).Count -lt 1) {
        Write-Warning "No Tests found in $TestModuleFolder"
    }
    
    Get-ChildItem $TestModuleFolder -Filter *.psm1 | Where-Object { -not ($_.Name -like "*Ignore*")} |
        Foreach-Object {
            $module = $_
            Write-Information "Analyzing Test in $module"
            Import-Module -Name $module.FullName -Force

            if ($module.BaseName -like "[0-9]*-Test-*") {
                $index = $module.BaseName.IndexOf('-')
                
                $newCommand = "New-$($module.BaseName.Substring($index + "-Test-".Length))"
                $test = & $newCommand -TestNumberPrefix $TestNumberPrefix
                $tests += $test
            }   
        }
    
    $results = Invoke-Tests -TestsArray $tests -TestsDescription "$testsDescription" -Hostname $Hostname
    return $results
}

Export-ModuleMember -Function *
