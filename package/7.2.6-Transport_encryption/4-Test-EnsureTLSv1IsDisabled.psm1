Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureTLSv1IsDisabled {
  $regKeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0'
  
  return Test-EnsureEncryptionIsDisabled -RegKeyPath $regKeyPath
}

function New-EnsureTLSv1IsDisabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureTLSv1IsDisabled } `
      -Description "Ensure TLSv1 is Disabled" `
      -Number "${TestNumberPrefix}.04"
    
    return $newTest
  }

Export-ModuleMember -Function *