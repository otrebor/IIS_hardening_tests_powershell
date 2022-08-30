function Test-Prerequisites {
    Try {
        Import-Module WebAdministration -ErrorAction Stop
    } Catch {
        throw "Unable to load required module."
    }

    if(-not ((Get-WindowsFeature Web-Url-Auth).Installed -EQ $true)) {
        throw "Unable to load required module 2"
    }

    if(-not (Test-IISIsInstalled -EQ $true)) {
        throw "Unable to find IIS"
    }


}

function Test-IISIsInstalled {
    if ((Get-WindowsFeature Web-Server).InstallState -eq "Installed") {
        Write-Information "IIS is installed"
        return $true
    } 
    else {
        Write-Information "IIS is not installed"
        return $false
    }
}


Export-ModuleMember -Function Test-Prerequisites