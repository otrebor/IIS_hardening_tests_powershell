function Repair-LogAndETWEventsLoggingIsEnabled {
    $expectedValue = "File,ETW"
    Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.applicationHost/sites/sitedefaults/logFile" -name "logTargetW3C" -Value $expectedValue
}

Export-ModuleMember -Function *