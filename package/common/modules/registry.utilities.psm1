function Get-RegistryValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $ItemParentPath,
        [Parameter(Mandatory)]
        [string]
        $ItemName,
        [Parameter(Mandatory)]
        [string]
        $PropertyName
    )

    If ((Test-Path -Path $ItemParentPath) -and (Test-Path -Path "$path\$ItemName")) {
        $Key = Get-Item "$ItemParentPath\$ItemName"
    
        if ($null -ne $Key.GetValue($PropertyName, $null)) {
            $value = Get-ItemProperty "$path\$ItemName" | Select-Object -ExpandProperty $PropertyName
            return $value
        } else {
          Write-Information "Property $PropertyName not found $ItemParentPath\$ItemName "
          return $null
        }
    } 
    
    Write-Information "Key not found $ItemParentPath\$ItemName"
    return $null
}

Export-ModuleMember -Function *