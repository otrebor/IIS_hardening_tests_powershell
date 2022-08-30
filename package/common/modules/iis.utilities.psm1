function Get-IISVersion {
    $version = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$env:SystemRoot\system32\inetsrv\InetMgr.exe").ProductVersion
    Write-Information "IIS version is $version"
    return $version
}
