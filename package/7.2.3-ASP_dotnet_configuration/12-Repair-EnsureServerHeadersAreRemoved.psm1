function Repair-EnsureServerHeadersAreRemoved {
  Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.webServer/security/requestFiltering" -name "removeServerHeader" -value "True"
}

Export-ModuleMember -Function *