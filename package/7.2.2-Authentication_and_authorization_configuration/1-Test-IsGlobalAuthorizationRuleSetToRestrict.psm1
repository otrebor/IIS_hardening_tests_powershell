function Get-WebSiteUsersInfo {
    return Get-WebSite | ForEach-Object {
        $site = $_.Name
        $config = Get-WebConfiguration -Filter "system.webServer/security/authorization" -PSPath "IIS:\Sites\$($_.Name)"
      
        $config.GetCollection() | ForEach-Object {
            $accessType = ($_.Attributes | Where-Object Name -EQ 'accessType').Value
            $users = ($_.Attributes | Where-Object Name -EQ 'users').Value
            $roles = ($_.Attributes | Where-Object Name -EQ 'roles').Value
      
            If (($accessType -EQ "Allow" -Or $accessType -EQ 0) -And ($users -eq "*" -or $roles -eq "?")) {
                [PSCustomObject]@{
                    "Name"       = $site
                    "AccessType" = $accessType
                    "Users"      = $users
                    "Roles"      = $roles
                    "Pass"       = $false
                }
            }
            Else {
                [PSCustomObject]@{
                    "Name"       = $site
                    "AccessType" = $accessType
                    "Users"      = $users
                    "Roles"      = $roles
                    "Pass"       = $true
                }
            }
        }
    }
}


function Test-IsGlobalAuthorizationRuleSetToRestrict {
    $results = Get-WebSiteUsersInfo | ForEach-Object {
        return $_.Pass
    }
    Write-Information "'Global authorization rule' is set to restrict access"
    return $results -notcontains $false
}

function New-IsGlobalAuthorizationRuleSetToRestrict {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-IsGlobalAuthorizationRuleSetToRestrict } `
        -Description "Ensure 'global authorization rule' is set to  restrict access" `
        -Number "${TestNumberPrefix}.1"

    return $newTest
}

Export-ModuleMember -Function *