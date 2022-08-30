Import-Module $PSScriptRoot\..\common\modules\encryption.utilities.psm1 -Force

function Test-EnsureTLSCipherSuiteOrderingIsConfigured {
  $regKeyPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Cryptography\Configuration\SSL\00010002'
  $result = Get-ItemProperty -path $regKeyPath -name 'Functions'

  return ($null -ne $result) -and ($null -ne $result.Functions) -and ('' -ne "$result.Functions")
}

function New-EnsureTLSCipherSuiteOrderingIsConfigured {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-EnsureTLSCipherSuiteOrderingIsConfigured } `
      -Description "Ensure TLS Cipher Suite ordering is Configured" `
      -Number "${TestNumberPrefix}.12"
    
    return $newTest
  }

Export-ModuleMember -Function * 