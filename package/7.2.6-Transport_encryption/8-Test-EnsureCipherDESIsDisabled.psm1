Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureCipherDESIsDisabled {
  $regKeyPath = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
  
  return Test-EnsureCipherIsDisabled -RegKeyPath $regKeyPath -CipherName 'DES'
}

function New-EnsureCipherDESIsDisabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureCipherDESIsDisabled } `
      -Description "Ensure DES Cipher Suites is Disabled" `
      -Number "${TestNumberPrefix}.08"
    
    return $newTest
  }

Export-ModuleMember -Function *