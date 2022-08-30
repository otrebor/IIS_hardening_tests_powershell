function Test-AdvancedLoggingIsEnabled {
    # The IS Advanced Logging is an extension for Internet Information Services (IIS) 7 is no longer available.
    # https://docs.microsoft.com/en-us/iis/extensions/advanced-logging-module/advanced-logging-for-iis-custom-logging
    return $false
}

function New-AdvancedLoggingIsEnabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-AdvancedLoggingIsEnabled } `
      -Description "Ensure Advanced IIS logging is enabled" `
      -Number "${TestNumberPrefix}.2"
    
    return $newTest
  }

Export-ModuleMember -Function *