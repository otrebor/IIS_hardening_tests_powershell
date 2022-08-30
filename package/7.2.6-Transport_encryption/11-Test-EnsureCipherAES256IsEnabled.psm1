Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureCipherAES256IsEnabled {
  $regKeyPath = 'HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
  
  return Test-EnsureCipherIsEnabled -RegKeyPath $regKeyPath -CipherName 'DES 168/168'
}

function New-EnsureCipherAES256IsEnabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureCipherAES256IsEnabled } `
      -Description "Ensure AES 256/256 Cipher Suite is Enabled" `
      -Number "${TestNumberPrefix}.11"
    
    return $newTest
  }

Export-ModuleMember -Function *