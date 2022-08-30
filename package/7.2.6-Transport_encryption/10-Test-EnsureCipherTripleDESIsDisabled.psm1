Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureCipherTripleDESIsDisabled {
  $regKeyPath = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
  
  return Test-EnsureCipherIsDisabled -RegKeyPath $regKeyPath -CipherName 'DES 168/168'
}

function New-EnsureCipherTripleDESIsDisabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureCipherTripleDESIsDisabled } `
      -Description "Ensure Triple DES 168/168 are Disabled" `
      -Number "${TestNumberPrefix}.10"
    
    return $newTest
  }

Export-ModuleMember -Function *