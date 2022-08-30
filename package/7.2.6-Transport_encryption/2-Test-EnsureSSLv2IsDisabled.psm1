Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureSSLv2IsDisabled {
  $regKeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0'
  
  return Test-EnsureEncryptionIsDisabled -RegKeyPath $regKeyPath
}

function New-EnsureSSLv2IsDisabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureSSLv2IsDisabled } `
      -Description "Ensure SSLv2 is Disabled" `
      -Number "${TestNumberPrefix}.02"
    
    return $newTest
  }

Export-ModuleMember -Function *