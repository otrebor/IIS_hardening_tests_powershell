Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureCipherNullIsDisabled {
  $regKeyPath = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
  
  return Test-EnsureCipherIsDisabled -RegKeyPath $regKeyPath -CipherName 'NULL'
}

function New-EnsureCipherNullIsDisabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureCipherNullIsDisabled } `
      -Description "Ensure NULL Cipher Suites is Disabled" `
      -Number "${TestNumberPrefix}.07"
    
    return $newTest
  }

Export-ModuleMember -Function *