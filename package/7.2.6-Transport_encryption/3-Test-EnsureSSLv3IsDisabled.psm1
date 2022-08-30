Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureSSLv3IsDisabled {
  $regKeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0'
  
  return Test-EnsureEncryptionIsDisabled -RegKeyPath $regKeyPath
}

function New-EnsureSSLv3IsDisabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureSSLv3IsDisabled } `
      -Description "Ensure SSLv3 is Disabled" `
      -Number "${TestNumberPrefix}.03"
    
    return $newTest
  }

Export-ModuleMember -Function *