function Get-WebSitePrincipalsInfo {
        return Get-Website | Foreach-Object {
            $mode = (Get-WebConfiguration -Filter 'system.web/authentication' -PSPath "IIS:\sites\$($_.Name)").mode
          
            If (($mode -NE 'forms') -And ($mode -NE 'Windows')) {
              [PSCustomObject]@{
                "Name" = $_.Name
                "Principals" = $false
              }
            } Else {
              [PSCustomObject]@{
                "Name" = $_.Name
                "Principals" = $true
              }
            }
          }
}


function Test-SensitiveFeaturesIsRestricted {
    $results = Get-WebSitePrincipalsInfo | ForEach-Object {
        return $_.Principals
    }
    Write-Information "sensitive site features is restricted to authenticated principals only"
    return $results -notcontains $false
}

function New-SensitiveFeaturesIsRestricted {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $TestNumberPrefix
    )
    $newTest = New-IISHardeningTest -TestBlock { Test-SensitiveFeaturesIsRestricted } `
        -Description "Ensure access to sensitive site features is restricted to authenticated principals only" `
        -Number "${TestNumberPrefix}.2"

    return $newTest
}

Export-ModuleMember -Function *