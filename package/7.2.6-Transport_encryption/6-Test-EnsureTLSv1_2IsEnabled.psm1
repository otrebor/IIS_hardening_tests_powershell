Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force
Import-Module $PSScriptRoot\..\common\modules\registry.utilities.psm1 -Force
function Test-EnsureEncryptionIsEnabled {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory)]
      [string]
      $RegKeyPath
  )

  $value1 = Get-RegistryValue -ItemParentPath $RegKeyPath `
      -ItemName 'Server' `
      -PropertyName 'Enabled' 

  $pass1 = ($null -eq $value1) -or ($value1 -eq '1')

  $value2 = Get-RegistryValue -ItemParentPath $RegKeyPath `
      -ItemName 'Server' `
      -PropertyName 'DisabledByDefault' 

  $pass2 = ($null -eq $value2) -or ($value2 -eq '0')

  return $pass1 -and $pass2
}

function Test-EnsureTLSv1_2IsEnabled {
  $regKeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1'
  
  return Test-EnsureEncryptionIsDisabled -RegKeyPath $regKeyPath
}

function New-EnsureTLSv1_2IsEnabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureTLSv1_2IsEnabled } `
      -Description "Ensure TLSv1.2 is Enabled" `
      -Number "${TestNumberPrefix}.06"
    
    return $newTest
  }

Export-ModuleMember -Function *