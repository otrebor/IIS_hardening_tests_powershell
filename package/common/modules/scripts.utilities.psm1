function Import-AllModulesInPath {
    [CmdletBinding()]
    param (
        [Parameter(mandatory)]
        [string]
        $Path
    )

    Get-ChildItem $Path -Filter *.psm1 | 
    Foreach-Object {
        $module = $_.FullName
        Write-Information "Importing $module"
        Import-Module -Name $module -Verbose -Force
    }
}

Export-ModuleMember -Function Import-AllModulesInPath