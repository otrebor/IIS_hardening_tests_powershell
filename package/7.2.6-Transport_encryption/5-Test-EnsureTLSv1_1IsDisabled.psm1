Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureTLSv1_1IsDisabled {
  $regKeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1'
  
  return Test-EnsureEncryptionIsDisabled -RegKeyPath $regKeyPath
}

function New-EnsureTLSv1_1IsDisabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureTLSv1_1IsDisabled } `
      -Description "Ensure TLSv1.1 is Disabled" `
      -Number "${TestNumberPrefix}.05"
    
    return $newTest
  }

Export-ModuleMember -Function *