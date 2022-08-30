Import-Module $PSScriptRoot\registry.utilities.psm1 -Force

function Test-EnsureEncryptionIsDisabled {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $RegKeyPath
    )
  
    $value1 = Get-RegistryValue -ItemParentPath $RegKeyPath `
        -ItemName 'Server' `
        -PropertyName 'Enabled' 

    $pass1 = ($null -eq $value1) -or ($value1 -eq '0')

    $value2 = Get-RegistryValue -ItemParentPath $RegKeyPath `
        -ItemName 'Server' `
        -PropertyName 'DisabledByDefault' 

    $pass2 = ($null -eq $value2) -or ($value2 -eq '1')
  
    $value3 = Get-RegistryValue -ItemParentPath $RegKeyPath `
        -ItemName 'Client' `
        -PropertyName 'Enabled' 
  
    $pass3 = ($null -ne $value3) -or ($value3 -eq '0')

    $value4 = Get-RegistryValue -ItemParentPath $RegKeyPath `
        -ItemName 'Client' `
        -PropertyName 'DisabledByDefault' 

    $pass4 = ($null -ne $value4) -or ($value4 -eq '1')

    return $pass1 -and $pass2 -and $pass3 -and $pass4 
}

function Test-EnsureCipherIsDisabled {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $RegKeyPath,
        [Parameter(Mandatory)]
        [string]
        $CipherName
    )
  
    $value = Get-RegistryValue -ItemParentPath $RegKeyPath `
        -ItemName $CipherName `
        -PropertyName 'Enabled' 

    $pass = ($null -eq $value) -or ($value -eq '0')

    return $pass 
}

function Test-EnsureCipherIsEnabled {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $RegKeyPath,
        [Parameter(Mandatory)]
        [string]
        $CipherName
    )
  
    $value = Get-RegistryValue -ItemParentPath $RegKeyPath `
        -ItemName $CipherName `
        -PropertyName 'Enabled' 

    $pass = ($null -ne $value) -or ($value -eq '1')

    return $pass 
}

Export-ModuleMember -Function *