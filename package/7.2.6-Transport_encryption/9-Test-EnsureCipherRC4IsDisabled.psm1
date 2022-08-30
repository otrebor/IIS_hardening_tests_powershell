Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureCipherRC4IsDisabled {
  $regKeyPath = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
  
  return (Test-EnsureCipherIsDisabled -RegKeyPath $regKeyPath -CipherName 'RC4 40/128') -and `
      (Test-EnsureCipherIsDisabled -RegKeyPath $regKeyPath -CipherName 'RC4 56/128') -and `
      (Test-EnsureCipherIsDisabled -RegKeyPath $regKeyPath -CipherName 'RC4 64/128') -and `
      (Test-EnsureCipherIsDisabled -RegKeyPath $regKeyPath -CipherName 'RC4 128/128') 
}

function New-EnsureCipherRC4IsDisabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureCipherRC4IsDisabled } `
      -Description "Ensure RC4 Cipher Suites is Disabled" `
      -Number "${TestNumberPrefix}.09"
    
    return $newTest
  }

Export-ModuleMember -Function *