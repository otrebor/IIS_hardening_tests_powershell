function Test-LogAndETWEventsLoggingIsEnabled {
    $expectedValue = "File,ETW"
    $value = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/sitedefaults/logFile" -name "logTargetW3C" 
    
    if ("$value" -ne "$expectedValue") {
        Write-Warning "Log events are written only in $value instead of $expectedValue"
        return $false
    }
    return $true
}

function New-LogAndETWEventsLoggingIsEnabled {
    [CmdletBinding()]
    param (
      [Parameter()]
      [string]
      $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-LogAndETWEventsLoggingIsEnabled } `
      -Description "Ensure 'ETW Logging' is enabled" `
      -Number "${TestNumberPrefix}.2"
    
    return $newTest
  }

Export-ModuleMember -Function *